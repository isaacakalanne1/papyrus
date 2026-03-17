//
//  ReaderMiddleware.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import ReduxKit

@MainActor
let readerMiddleware: Middleware<ReaderState, ReaderAction,  ReaderEnvironmentProtocol> = { state, action, environment in
    switch action {
    case .createStory(let step, var story):
        switch step {
        case .idle:
            return nil
            
        case .initial:
            guard let initialStory = state.story else {
                return nil
            }
            return .createStory(step: .identifyingTheme, story: initialStory)
            
        case .sequel:
            guard let currentStory = state.story,
                  let sequelStory = state.sequelStory else {
                return nil
            }
            do {
                try await environment.saveStory(currentStory)
                // First create theme for sequel
                let themedSequelStory = try await environment.createStoryTheme(story: sequelStory)
                // Then create plot outline with theme
                let sequelWithPlot = try await environment.createSequelPlotOutline(
                    story: themedSequelStory,
                    previousStory: currentStory
                )
                return .createStory(step: .creatingChapterBreakdown, story: sequelWithPlot)
            } catch {
                return nil
            }
            
        case .identifyingTheme:
            guard var story = story else { return nil }
            do {
                story = try await environment.createStoryTheme(story: story)
                return .createStory(step: .creatingPlotOutline, story: story)
            } catch {
                return nil
            }
            
        case .creatingPlotOutline:
            guard var story = story else { return nil }
            do {
                story = try await environment.createPlotOutline(story: story)
                return .createStory(step: .creatingChapterBreakdown, story: story)
            } catch {
                return nil
            }
            
        case .creatingChapterBreakdown:
            guard var story = story else { return nil }
            do {
                story = try await environment.createChapterBreakdown(story: story)
                if story.maxNumberOfChapters > 0 {
                    return .createStory(step: .writingChapter, story: story)
                } else {
                    return .createStory(step: .gettingStoryDetails, story: story)
                }
            } catch {
                return nil
            }
            
        case .gettingStoryDetails:
            guard var story = story else { return nil }
            do {
                story = try await environment.getStoryDetails(story: story)
                return .createStory(step: .gettingChapterTitle, story: story)
            } catch {
                return nil
            }
            
        case .gettingChapterTitle:
            guard var story = story else { return nil }
            do {
                story = try await environment.getChapterTitle(story: story)
                return .createStory(step: .writingChapter, story: story)
            } catch {
                return nil
            }
            
        case .writingChapter:
            guard var story = story else { return nil }
            
            // Check if user is at the free limit
            let isAtFreeLimit = story.chapters.count >= 2
            
            var isSubscribed = state.settingsState.isSubscribed
            
            // If the state says not subscribed, double check with the environment
            // to avoid showing the sheet if the state is just stale.
            if !isSubscribed, isAtFreeLimit {
                isSubscribed = await (try? environment.subscriptionEnvironment.checkSubscriptionStatus()) ?? false
            }
            
            if !isSubscribed, isAtFreeLimit {
                return .setShowSubscriptionSheet(true)
            }
            
            // Check if story is at its technical max
            if story.chapters.count >= story.maxNumberOfChapters {
                return nil
            }

            do {
                story = try await environment.createChapter(story: story)
                return .onCreatedStory(story)
            } catch {
                return .failedToCreateStory
            }
            
        case .analyzingStructure, .preparingNarrative:
            return nil
        }

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
    case .onCreatedStory(let story):
        if state.shouldNavigateAfterChapterCreation {
            return .updateChapterIndex(story, story.chapters.count - 1)
        } else {
            return .saveStory(story)
        }
        case .updateChapterIndex(let story, let index):
            var updatedStory = story
            updatedStory.chapterIndex = index
            updatedStory.scrollOffset = 0
            return .saveStory(updatedStory)
    case .saveStory(let story):
        do {
            // Save the current story first
            try await environment.saveStory(story)
            
            // Update prequel stories with sequel relationship
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
            return .failedToCreateStory
        }
    case .updateScrollOffset(let offset):
        // Save the story after scroll offset is updated
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
            .setScrollViewHeight,
            .setShouldNavigateAfterChapterCreation:
        return nil
    }
}
