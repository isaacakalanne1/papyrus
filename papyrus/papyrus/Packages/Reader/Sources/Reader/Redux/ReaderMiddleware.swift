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
    case .createStory:
        if !state.canCreateChapter {
            return .setShowSubscriptionSheet(true)
        }
        return .beginCreateStory
    case .createSequel:
        if !state.canCreateChapter {
            return .setShowSubscriptionSheet(true)
        }
        return .beginCreateSequel
    case .createStoryTheme(var story):
        do {
            story = try await environment.createStoryTheme(story: story)
            return .onCreatedThemeDescription(story)
        } catch {
            return .failedToCreateChapter
        }
    case .onCreatedThemeDescription(let story):
        return .createPlotOutline(story)
    case .createPlotOutline(var story):
        do {
            story = try await environment.createPlotOutline(story: story)
            return .onCreatedPlotOutline(story)
        } catch {
            return .failedToCreateChapter
        }
    case .onCreatedPlotOutline(let story):
        return .createChapterBreakdown(story)
    case .createChapterBreakdown(var story):
        do {
            story = try await environment.createChapterBreakdown(story: story)
            return .onCreatedChapterBreakdown(story)
        } catch {
            return .failedToCreateChapter
        }
    case .onCreatedChapterBreakdown(let story):
        if story.maxNumberOfChapters > 0 {
            return .beginCreateChapter(story, .visible)
        } else {
            return .getStoryDetails(story)
        }
    case .getStoryDetails(var story):
        do {
            story = try await environment.getStoryDetails(story: story)
            return .onGetStoryDetails(story)
        } catch {
            return .failedToCreateChapter
        }
    case .onGetStoryDetails(let story):
        return .getChapterTitle(story)
    case .getChapterTitle(var story):
        do {
            story = try await environment.getChapterTitle(story: story)
            return .onGetChapterTitle(story)
        } catch {
            return .failedToCreateChapter
        }
    case .onGetChapterTitle(let story):
        return .beginCreateChapter(story, .visible)
    case .createChapter(let story):
        if !state.canCreateChapter {
            return .setShowSubscriptionSheet(true)
        }
        return .beginCreateChapter(story, .visible)
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
    case .onCreatedChapter(let story):
        if story.chapters.count == story.maxNumberOfChapters + 1 {
            return .updateChapterIndex(story, story.chapters.count - 1)
        }
        return nil
    case .updateChapterIndex(let story, let index):
        // If viewing the latest available chapter, trigger chapter creation with hidden status
        let isViewingLatestChapter = index == story.chapters.count - 1
        let canCreateMore = story.chapters.count < story.maxNumberOfChapters
        
        if isViewingLatestChapter && canCreateMore && state.canCreateChapter {
            // Start creating the next chapter with hidden status
            return .beginCreateChapter(story, .hidden)
        }
        
        return .saveStory(story)
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
            return .failedToCreateChapter
        }
    case .updateScrollOffset:
        // Save the story after scroll offset is updated
        if let story = state.story {
            do {
                try await environment.saveStory(story)
                return nil
            } catch {
                return .failedToCreateChapter
            }
        }
        return nil
    case .loadSubscriptions:
        await environment.loadSubscriptions()
        return nil
    case .beginCreateStory:
        guard let story = state.story else {
            return .failedToCreateChapter
        }
        return .createStoryTheme(story)
    case .beginCreateSequel:
        guard var currentStory = state.story,
              var sequelStory = state.sequelStory else {
            return .failedToCreateChapter
        }

        do {
            try await environment.saveStory(currentStory)
            // First create theme for sequel
            let themedSequelStory = try await environment.createStoryTheme(story: sequelStory)
            // Then create plot outline with theme
            let sequelStory = try await environment.createSequelPlotOutline(
                story: themedSequelStory,
                previousStory: currentStory
            )
            return .onCreatedPlotOutline(sequelStory)
        } catch {
            return .failedToCreateChapter
        }
    case .beginCreateChapter(var story, _):
        do {
            story = try await environment.createChapter(story: story)
            return .onCreatedChapter(story)
        } catch {
            return .failedToCreateChapter
        }
    case .setStory(let story):
        if let story {
            return .updateChapterIndex(story, story.chapterIndex)
        }
        return nil
    case .failedToCreateChapter,
            .updateSetting,
            .updateMainCharacter,
            .onLoadedStories,
            .failedToLoadStories,
            .onDeletedStory,
            .refreshSettings,
            .setShowStoryForm,
            .setShowSubscriptionSheet,
            .setSelectedStoryForDetails:
        return nil
    }
}
