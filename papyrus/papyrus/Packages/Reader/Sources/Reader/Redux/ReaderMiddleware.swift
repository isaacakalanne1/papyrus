//
//  ReaderMiddleware.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import ReduxKit

@MainActor
let readerMiddleware: Middleware<ReaderState, ReaderAction,  ReaderEnvironmentProtocol> = { state, action, environment in
    switch action {
    case .createStory:
        guard let story = state.story else {
            return .failedToCreateChapter
        }
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
            return .createChapter(story)
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
        return .createChapter(story)
    case .createChapter(var story):
        do {
            story = try await environment.createChapter(story: story)
            return .onCreatedChapter(story)
        } catch {
            return .failedToCreateChapter
        }
    case .loadAllStories:
        do {
            let stories = try await environment.loadAllStories()
            return .onLoadedStories(stories)
        } catch {
            return .failedToLoadStories
        }
    case .onCreatedChapter(let story):
        do {
            try await environment.saveStory(story)
            return nil
        } catch {
            return .failedToCreateChapter
        }
    case .failedToCreateChapter,
            .updateSetting,
            .updateMainCharacter,
            .onLoadedStories,
            .failedToLoadStories,
            .setStory,
            .updateChapterIndex:
        return nil
    }
}
