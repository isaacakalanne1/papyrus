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
        if !state.canCreateChapter {
            let isSubscribed = await (try? environment.subscriptionEnvironment.checkSubscriptionStatus()) ?? false
            if !isSubscribed { return .setShowSubscriptionSheet(true) }
        }
        return .beginCreateStory

    case .createSequel:
        if !state.canCreateChapter {
            let isSubscribed = await (try? environment.subscriptionEnvironment.checkSubscriptionStatus()) ?? false
            if !isSubscribed { return .setShowSubscriptionSheet(true) }
        }
        return .beginCreateSequel

    case .createChapter(let story):
        if !state.canCreateChapter {
            let isSubscribed = await (try? environment.subscriptionEnvironment.checkSubscriptionStatus()) ?? false
            if !isSubscribed { return .setShowSubscriptionSheet(true) }
        }
        return .beginCreateChapter(story)

    // MARK: - Story Creation Pipeline

    case .beginCreateStory:
        guard let story = state.story else { return .failedToCreateChapter(.beginCreateStory) }
        return .createPlotOutline(story)

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

    case .createStoryTheme(let story):
        do {
            let themedStory = try await environment.createStoryTheme(story: story)
            return .onCreatedThemeDescription(themedStory)
        } catch {
            return .failedToCreateChapter(.createStoryTheme(story))
        }

    case .onCreatedThemeDescription(let story):
        return .createPlotOutline(story)

    case .createPlotOutline(let story):
        do {
            let storyWithPlot = try await environment.createPlotOutline(story: story)
            return .onCreatedPlotOutline(storyWithPlot)
        } catch {
            return .failedToCreateChapter(.createPlotOutline(story))
        }

    case .onCreatedPlotOutline(let story):
        return .createChapterBreakdown(story)

    case .createChapterBreakdown(let story):
        do {
            let storyWithBreakdown = try await environment.createChapterBreakdown(story: story)
            return .onCreatedChapterBreakdown(storyWithBreakdown)
        } catch {
            return .failedToCreateChapter(.createChapterBreakdown(story))
        }

    case .onCreatedChapterBreakdown(let story):
        if story.maxNumberOfChapters > 0 {
            return .beginCreateChapter(story)
        } else {
            return .getStoryDetails(story)
        }

    case .getStoryDetails(let story):
        do {
            let storyWithDetails = try await environment.getStoryDetails(story: story)
            return .onGetStoryDetails(storyWithDetails)
        } catch {
            return .failedToCreateChapter(.getStoryDetails(story))
        }

    case .onGetStoryDetails(let story):
        return .getChapterTitle(story)

    case .getChapterTitle(let story):
        do {
            let storyWithTitle = try await environment.getChapterTitle(story: story)
            return .onGetChapterTitle(storyWithTitle)
        } catch {
            return .failedToCreateChapter(.getChapterTitle(story))
        }

    case .onGetChapterTitle(let story):
        return .beginCreateChapter(story)

    case .beginCreateChapter(let story):
        do {
            let storyWithChapter = try await environment.createChapter(story: story)
            return .onCreatedChapter(storyWithChapter)
        } catch {
            return .failedToCreateChapter(.beginCreateChapter(story))
        }

    case .onCreatedChapter(let story):
        return .updateChapterIndex(story, story.chapters.count - 1)

    // MARK: - Story Management

    case .loadAllStories:
        do {
            let stories = try await environment.loadAllStories()
            return .onLoadedStories(stories)
        } catch {
            return .failedToLoadStories
        }

    case .deleteStory(let id):
        do {
            try await environment.deleteStory(withId: id)
            return .onDeletedStory(id)
        } catch {
            return .failedToLoadStories
        }

    case .updateChapterIndex(let story, let index):
        var updatedStory = story
        updatedStory.chapterIndex = max(0, min(index, story.chapters.count - 1))
        updatedStory.scrollOffset = 0
        return .saveStory(updatedStory)

    case .saveStory(let story):
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

    case .updateScrollOffset(let offset):
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

    case .retryGeneration(let retryAction):
        return retryAction

    case .confirmDeleteStory:
        return nil

    case .cancelDeleteStory:
        return nil

    case .loadSubscriptions:
        await environment.loadSubscriptions()
        return nil

    case .updatePerspective(let p):
        var updatedSettings = state.settingsState
        updatedSettings.perspective = p
        try? await environment.settingsEnvironment.saveSettings(updatedSettings)
        return nil

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
         .setScrollViewHeight:
        return nil
    }
}
