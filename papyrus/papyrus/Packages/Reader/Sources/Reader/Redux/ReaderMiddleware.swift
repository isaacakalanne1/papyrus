//
//  ReaderMiddleware.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import ReduxKit

@MainActor
let readerMiddleware: Middleware<ReaderState, ReaderAction, ReaderEnvironmentProtocol> = { state, action, environment in
    switch action {
    // MARK: - Entry Points (subscription gate lives here)

    case .createStory:
        return .beginCreateStory

    case .createInteractiveStory:
        return .beginCreateInteractiveStory

    case .createSequel:
        if !state.canCreateChapter {
            let isSubscribed = await (try? environment.subscriptionEnvironment.checkSubscriptionStatus()) ?? false
            if !isSubscribed { return .setShowSubscriptionSheet(true) }
        }
        return .beginCreateSequel

    case let .createChapter(story):
        if !state.canCreateChapter {
            let isSubscribed = await (try? environment.subscriptionEnvironment.checkSubscriptionStatus()) ?? false
            if !isSubscribed { return .setShowSubscriptionSheet(true) }
        }
        return .beginCreateChapter(story)

    // MARK: - Story Creation Pipeline

    case .beginCreateStory:
        guard let story = state.story else { return .failedToCreateChapter(.beginCreateStory) }
        return .createStoryTheme(story)

    case .beginCreateInteractiveStory:
        guard let story = state.story else { return .failedToCreateChapter(.beginCreateInteractiveStory) }
        return .generateFirstParagraph(story)

    case let .generateFirstParagraph(story):
        do {
            let storyWithParagraph = try await environment.generateParagraph(story: story, sentenceCount: state.settingsState.sentenceCount)
            return .onGeneratedFirstParagraph(storyWithParagraph)
        } catch {
            return .failedToCreateChapter(.generateFirstParagraph(story))
        }

    case let .onGeneratedFirstParagraph(story):
        return .getChapterTitle(story)

    case let .submitInteractiveAction(story, action):
        if !state.canGenerateParagraph {
            let isSubscribed = await (try? environment.subscriptionEnvironment.checkSubscriptionStatus()) ?? false
            if !isSubscribed { return .setShowSubscriptionSheet(true) }
        }

        var pendingStory = story
        pendingStory.chapters.append(.init(content: "", action: action ?? nil))
        return .beginGenerateParagraph(pendingStory)

    case let .beginGenerateParagraph(story):
        do {
            let storyWithParagraph = try await environment.generateParagraph(story: story, sentenceCount: state.settingsState.sentenceCount)
            return .onGeneratedParagraph(storyWithParagraph)
        } catch {
            return .failedToCreateChapter(.beginGenerateParagraph(story))
        }

    case let .onGeneratedParagraph(story):
        return .saveStory(story)

    case .beginCreateSequel:
        guard let currentStory = state.story,
              let sequelStory = state.sequelStory else { return .failedToCreateChapter(.beginCreateSequel) }
        do {
            try await environment.saveStory(currentStory)
            let sequelWithPlot = try await environment.createSequelPlotOutline(
                story: sequelStory,
                previousStory: currentStory
            )
            return .onCreatedPlotOutline(sequelWithPlot)
        } catch {
            return .failedToCreateChapter(.beginCreateSequel)
        }

    case let .createStoryTheme(story):
        do {
            let themedStory = try await environment.createStoryTheme(story: story)
            return .onCreatedThemeDescription(themedStory)
        } catch {
            return .failedToCreateChapter(.createStoryTheme(story))
        }

    case let .onCreatedThemeDescription(story):
        return .createPlotOutline(story)

    case let .createPlotOutline(story):
        do {
            let storyWithPlot = try await environment.createPlotOutline(story: story)
            return .onCreatedPlotOutline(storyWithPlot)
        } catch {
            return .failedToCreateChapter(.createPlotOutline(story))
        }

    case let .onCreatedPlotOutline(story):
        return .createChapterBreakdown(story)

    case let .createChapterBreakdown(story):
        do {
            let storyWithBreakdown = try await environment.createChapterBreakdown(story: story)
            return .onCreatedChapterBreakdown(storyWithBreakdown)
        } catch {
            return .failedToCreateChapter(.createChapterBreakdown(story))
        }

    case let .onCreatedChapterBreakdown(story):
        if story.maxNumberOfChapters > 0 {
            return .beginCreateChapter(story)
        } else {
            return .getStoryDetails(story)
        }

    case let .getStoryDetails(story):
        do {
            let storyWithDetails = try await environment.getStoryDetails(story: story)
            return .onGetStoryDetails(storyWithDetails)
        } catch {
            return .failedToCreateChapter(.getStoryDetails(story))
        }

    case let .onGetStoryDetails(story):
        return .getChapterTitle(story)

    case let .getChapterTitle(story):
        do {
            let storyWithTitle = try await environment.getChapterTitle(story: story)
            return .onGetChapterTitle(storyWithTitle)
        } catch {
            return .failedToCreateChapter(.getChapterTitle(story))
        }

    case let .onGetChapterTitle(story):
        return story.mode == .interactive ? .saveStory(story) : .beginCreateChapter(story)

    case let .beginCreateChapter(story):
        do {
            let storyWithChapter = try await environment.createChapter(story: story)
            return .onCreatedChapter(storyWithChapter)
        } catch {
            return .failedToCreateChapter(.beginCreateChapter(story))
        }

    case let .onCreatedChapter(story):
        guard state.story?.id == story.id, let storyToSave = state.story else { return nil }
        return .saveStory(storyToSave)

    // MARK: - Story Management

    case .loadAllStories:
        do {
            let stories = try await environment.loadAllStories()
            return .onLoadedStories(stories)
        } catch {
            return .failedToLoadStories
        }

    case let .deleteStory(id):
        do {
            try await environment.deleteStory(withId: id)
            return .onDeletedStory(id)
        } catch {
            return .failedToLoadStories
        }

    case let .updateChapterIndex(story, index):
        var updatedStory = story
        updatedStory.chapterIndex = max(0, min(index, story.chapters.count - 1))
        updatedStory.scrollOffset = 0
        return .saveStory(updatedStory)

    case let .saveStory(story):
        do {
            try await environment.saveStory(story)
            for prequelId in story.prequelIds {
                if var prequelStory = try await environment.loadStory(withId: prequelId) {
                    if !prequelStory.sequelIds.contains(story.id) {
                        prequelStory.sequelIds.append(story.id)
                        try await environment.saveStory(prequelStory)
                    }
                }
            }
            return nil
        } catch {
            return nil
        }

    case let .updateScrollOffset(offset):
        if var story = state.story {
            story.scrollOffset = offset
            do {
                try await environment.saveStory(story)
                return nil
            } catch {
                return nil
            }
        }
        return nil

    case let .retryGeneration(retryAction):
        return retryAction

    case .confirmDeleteStory:
        return nil

    case .cancelDeleteStory:
        return nil

    case .loadSubscriptions:
        await environment.loadSubscriptions()
        return nil

    case let .updatePerspective(p):
        var updatedSettings = state.settingsState
        updatedSettings.perspective = p
        try? await environment.settingsEnvironment.saveSettings(updatedSettings)
        return nil

    case let .setSentenceCount(count):
        var updatedSettings = state.settingsState
        updatedSettings.sentenceCount = count
        try? await environment.settingsEnvironment.saveSettings(updatedSettings)
        return nil

    case let .updateStoryTitle(story, title):
        var updatedStory = story
        updatedStory.title = title
        return .saveStory(updatedStory)

    case .failedToCreateChapter(_),
         .dismissGenerationError,
         .failedToLoadStories,
         .updateSetting,
         .updateMainCharacter,
         .onLoadedStories,
         .setStory,
         .onDeletedStory,
         .failedToDeleteStory,
         .refreshSettings,
         .setShowStoryForm,
         .setShowSubscriptionSheet,
         .setSelectedStoryForDetails,
         .setFocusedField,
         .setMenuStatus,
         .setDragOffset,
         .setIsSequelMode,
         .setCurrentScrollOffset,
         .reuseStoryDetails,
         .setScrollViewHeight,
         .setInteractiveMode,
         .setInteractiveInputText,
         .undoInteractiveChapter,
         .redoInteractiveChapter:
        return nil
    }
}
