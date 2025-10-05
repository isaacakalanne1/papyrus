//
//  ReaderMiddleware.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import ReduxKit
import Settings

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
            return .beginCreateChapter(story)
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
        return .beginCreateChapter(story)
    case .createChapter(let story):
        if !state.canCreateChapter {
            return .setShowSubscriptionSheet(true)
        }
        return .beginCreateChapter(story)
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
        return .updateChapterIndex(story, story.chapters.count - 1)
    case .updateChapterIndex(let story, _):
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
        return .createPlotOutline(story)
    case .beginCreateSequel:
        guard var currentStory = state.story,
              var sequelStory = state.sequelStory else {
            return .failedToCreateChapter
        }

        do {
            try await environment.saveStory(currentStory)
            let sequelStory = try await environment.createSequelPlotOutline(
                story: sequelStory,
                previousStory: currentStory
            )
            return .onCreatedPlotOutline(sequelStory)
        } catch {
            return .failedToCreateChapter
        }
    case .beginCreateChapter(var story):
        do {
            story = try await environment.createChapter(story: story)
            return .onCreatedChapter(story)
        } catch {
            return .failedToCreateChapter
        }
    case .failedToCreateChapter,
            .updateSetting,
            .updateMainCharacter,
            .onLoadedStories,
            .failedToLoadStories,
            .setStory,
            .onDeletedStory,
            .refreshSettings,
            .setShowStoryForm,
            .setShowSubscriptionSheet,
            .setSelectedStoryForDetails:
        return nil
    }
}
