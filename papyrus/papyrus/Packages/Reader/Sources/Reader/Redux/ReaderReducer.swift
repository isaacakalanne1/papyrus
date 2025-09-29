//
//  ReaderReducer.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import ReduxKit

@MainActor
let readerReducer: Reducer<ReaderState, ReaderAction> = { state, action in
    var newState = state
    switch action {
    case .createStory:
        newState.isLoading = true
        newState.story = .init(
            mainCharacter: newState.mainCharacter,
            setting: newState.setting
        )
    case .createPlotOutline:
        newState.isLoading = true
    case .onCreatedPlotOutline(let story):
        newState.story = story
        newState.isLoading = true // Keep loading for next step
    case .createChapterBreakdown:
        newState.isLoading = true
    case .onCreatedChapterBreakdown(let story):
        newState.story = story
        newState.isLoading = true // Keep loading for next step
    case .getStoryDetails:
        newState.isLoading = true
    case .onGetStoryDetails(let story):
        newState.story = story
        newState.isLoading = true // Keep loading for next step
    case .getChapterTitle:
        newState.isLoading = true
    case .onGetChapterTitle(let story):
        newState.story = story
        newState.isLoading = true // Keep loading for next step
    case .onCreatedChapter(let story):
        newState.story = story
        newState.isLoading = false
        // Update the story in loadedStories if it exists, or add it if not present
        if var loadedStories = newState.loadedStories {
            if let existingIndex = loadedStories.firstIndex(where: { $0.id == story.id }) {
                // Update existing story
                loadedStories[existingIndex] = story
            } else {
                // Add new story if not present
                loadedStories.append(story)
            }
            newState.loadedStories = loadedStories
        } else {
            // Initialize loadedStories with the new story if it was nil
            newState.loadedStories = [story]
        }
    case .updateMainCharacter(let mainCharacter):
        newState.mainCharacter = mainCharacter
    case .updateSetting(let setting):
        newState.setting = setting
    case .createChapter:
        newState.isLoading = true
    case .failedToCreateChapter:
        newState.isLoading = false
    case .loadAllStories:
        newState.isLoading = true
    case .onLoadedStories(let stories):
        newState.loadedStories = stories
        newState.isLoading = false
    case .failedToLoadStories:
        newState.isLoading = false
    case .setStory(let story):
        newState.story = story
    case .updateChapterIndex(let index):
        if var story = newState.story {
            story.chapterIndex = max(0, min(index, story.chapters.count - 1))
            newState.story = story
        }
    }
    return newState
}
