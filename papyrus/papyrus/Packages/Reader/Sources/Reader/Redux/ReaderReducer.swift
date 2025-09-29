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
        newState.loadingStep = .buildingStory
        newState.story = .init(
            mainCharacter: newState.mainCharacter,
            setting: newState.setting
        )
    case .createPlotOutline:
        newState.isLoading = true
        newState.loadingStep = .buildingStory
    case .onCreatedPlotOutline:
        newState.isLoading = true // Keep loading for next step
    case .createChapterBreakdown:
        newState.isLoading = true
        newState.loadingStep = .refiningDetails
    case .onCreatedChapterBreakdown:
        newState.isLoading = true // Keep loading for next step
    case .getStoryDetails:
        newState.isLoading = true
        newState.loadingStep = .expandingNarrative
    case .onGetStoryDetails:
        newState.isLoading = true // Keep loading for next step
    case .getChapterTitle:
        newState.isLoading = true
        newState.loadingStep = .addingDepth
    case .onGetChapterTitle:
        newState.isLoading = true // Keep loading for next step
    case .onCreatedChapter(let story):
        // Only update the story if current story is nil
        if newState.story?.id == story.id {
            newState.story = story
        }
        newState.isLoading = false
        newState.loadingStep = .idle
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
        newState.loadingStep = .finalizingStory
    case .failedToCreateChapter:
        newState.isLoading = false
        newState.loadingStep = .idle
    case .loadAllStories:
        newState.isLoading = true
    case .onLoadedStories(let stories):
        newState.loadedStories = stories
        newState.isLoading = false
        newState.loadingStep = .idle
    case .failedToLoadStories:
        newState.isLoading = false
        newState.loadingStep = .idle
    case .setStory(let story):
        newState.story = story
    case .deleteStory:
        break // Handled by middleware
    case .onDeletedStory(let deletedStoryId):
        // Remove the deleted story from loadedStories
        if var loadedStories = newState.loadedStories {
            loadedStories.removeAll { $0.id == deletedStoryId }
            newState.loadedStories = loadedStories
        }
        // If the currently viewed story was deleted, clear it
        if newState.story?.id == deletedStoryId {
            newState.story = nil
        }
    case .updateChapterIndex(let index):
        if var story = newState.story {
            story.chapterIndex = max(0, min(index, story.chapters.count - 1))
            newState.story = story
        }
    }
    return newState
}
