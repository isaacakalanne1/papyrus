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
        guard var story = state.story else {
            return .failedToCreateChapter
        }
        
        do {
            story = try await environment.createChapter(story: story)
            return .onCreatedChapter(story)
        } catch {
            return .failedToCreateChapter
        }
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
    case .onCreatedChapter,
            .failedToCreateChapter,
            .updateSetting,
            .updateMainCharacter,
            .onLoadedStories,
            .failedToLoadStories,
            .setStory,
            .updateChapterIndex:
        return nil
    }
}
