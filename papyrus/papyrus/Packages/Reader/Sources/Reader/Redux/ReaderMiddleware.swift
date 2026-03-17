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
    case .createStory(let step, var story, let navigateOnCompletion):
        switch step {
        case .idle:
            return nil

        case .initial:
            guard let initialStory = state.story else { return nil }
            return .createStory(step: .identifyingTheme, story: initialStory, navigateOnCompletion: navigateOnCompletion)

        case .sequel:
            guard let currentStory = state.story,
                  let sequelStory = state.sequelStory else {
                return nil
            }
            do {
                try await environment.saveStory(currentStory)
                let themedSequelStory = try await environment.createStoryTheme(story: sequelStory)
                let sequelWithPlot = try await environment.createSequelPlotOutline(
                    story: themedSequelStory,
                    previousStory: currentStory
                )
                return .createStory(step: .creatingChapterBreakdown, story: sequelWithPlot, navigateOnCompletion: navigateOnCompletion)
            } catch {
                return .failedToCreateStory
            }

        case .identifyingTheme:
            guard var story = story else { return .failedToCreateStory }
            do {
                story = try await environment.createStoryTheme(story: story)
                return .createStory(step: .creatingPlotOutline, story: story, navigateOnCompletion: navigateOnCompletion)
            } catch {
                return .failedToCreateStory
            }

        case .creatingPlotOutline:
            guard var story = story else { return .failedToCreateStory }
            do {
                story = try await environment.createPlotOutline(story: story)
                return .createStory(step: .creatingChapterBreakdown, story: story, navigateOnCompletion: navigateOnCompletion)
            } catch {
                return .failedToCreateStory
            }

        case .creatingChapterBreakdown:
            guard var story = story else { return .failedToCreateStory }
            do {
                story = try await environment.createChapterBreakdown(story: story)
                if story.maxNumberOfChapters > 0 {
                    return .createStory(step: .writingChapter, story: story, navigateOnCompletion: navigateOnCompletion)
                } else {
                    return .createStory(step: .gettingStoryDetails, story: story, navigateOnCompletion: navigateOnCompletion)
                }
            } catch {
                return .failedToCreateStory
            }

        case .gettingStoryDetails:
            guard var story = story else { return .failedToCreateStory }
            do {
                story = try await environment.getStoryDetails(story: story)
                return .createStory(step: .gettingChapterTitle, story: story, navigateOnCompletion: navigateOnCompletion)
            } catch {
                return .failedToCreateStory
            }

        case .gettingChapterTitle:
            guard var story = story else { return .failedToCreateStory }
            do {
                story = try await environment.getChapterTitle(story: story)
                return .createStory(step: .writingChapter, story: story, navigateOnCompletion: navigateOnCompletion)
            } catch {
                return .failedToCreateStory
            }

        case .writingChapter:
            guard var story = story else { return .failedToCreateStory }

            let isAtFreeLimit = story.chapters.count >= 2
            var isSubscribed = state.settingsState.isSubscribed

            if !isSubscribed, isAtFreeLimit {
                isSubscribed = await (try? environment.subscriptionEnvironment.checkSubscriptionStatus()) ?? false
            }

            if !isSubscribed, isAtFreeLimit {
                return .setShowSubscriptionSheet(true)
            }

            if story.chapters.count >= story.maxNumberOfChapters {
                return nil
            }

            do {
                story = try await environment.createChapter(story: story)
                return .onCreatedStory(story, navigateOnCompletion: navigateOnCompletion)
            } catch {
                return .failedToCreateStory
            }
        }

    case .onCreatedStory(let story, let navigateOnCompletion):
        var storyToSave = story
        if navigateOnCompletion {
            storyToSave.chapterIndex = story.chapters.count - 1
            storyToSave.scrollOffset = 0
        }
        return .saveStory(storyToSave)

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
            return .failedToDeleteStory(id)
        }

    case .updateChapterIndex(let story, let index):
        var updatedStory = story
        updatedStory.chapterIndex = max(0, min(index, story.chapters.count - 1))
        updatedStory.scrollOffset = 0
        return .saveStory(updatedStory)

    case .saveStory(let story):
        do {
            try await environment.saveStoryWithRelationships(story)
            return nil
        } catch {
            return .failedToCreateStory
        }

    case .updateScrollOffset(let offset):
        if var story = state.story {
            story.scrollOffset = offset
            do {
                try await environment.saveStory(story)
                return nil
            } catch {
                return .failedToCreateStory
            }
        }
        return nil

    case .loadSubscriptions:
        await environment.loadSubscriptions()
        return nil

    case .updateSetting,
            .failedToCreateStory,
            .failedToDeleteStory,
            .updateMainCharacter,
            .onLoadedStories,
            .failedToLoadStories,
            .setStory,
            .onDeletedStory,
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
