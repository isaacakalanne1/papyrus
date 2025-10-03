//
//  ReaderReducer.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import ReduxKit

@MainActor
let readerReducer: Reducer<ReaderState, ReaderAction> = { state, action in
    var newState = state
    switch action {
    case .createStory:
        newState.isLoading = true
        newState.loadingStep = .creatingPlotOutline
        newState.story = .init(
            mainCharacter: newState.mainCharacter,
            setting: newState.setting
        )
    case .createSequel:
        newState.isLoading = true
        newState.loadingStep = .creatingPlotOutline

        newState.sequelStory = newState.story
        newState.sequelStory?.id = UUID()
        newState.sequelStory?.mainCharacter = newState.mainCharacter
        newState.sequelStory?.setting = newState.setting
        newState.sequelStory?.chapters = []
        newState.sequelStory?.chapterIndex = 0
        if let prequelId = newState.story?.id {
            newState.sequelStory?.prequelIds.append(prequelId)
        }
    case .createPlotOutline:
        newState.isLoading = true
        newState.loadingStep = .creatingPlotOutline
    case .onCreatedPlotOutline:
        newState.isLoading = true // Keep loading for next step
    case .createChapterBreakdown:
        newState.isLoading = true
        newState.loadingStep = .creatingChapterBreakdown
    case .onCreatedChapterBreakdown:
        newState.isLoading = true // Keep loading for next step
    case .getStoryDetails:
        newState.isLoading = true
        newState.loadingStep = .analyzingStructure
    case .onGetStoryDetails:
        newState.isLoading = true // Keep loading for next step
    case .getChapterTitle:
        newState.isLoading = true
        newState.loadingStep = .preparingNarrative
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
        newState.loadingStep = .writingChapter
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
            story.scrollOffset = 0
            story.chapterIndex = max(0, min(index, story.chapters.count - 1))
            newState.story = story
        }
    case .updateScrollOffset(let offset):
        if var story = newState.story {
            story.scrollOffset = offset
            newState.story = story
            
            // Update the story in loadedStories as well
            if var loadedStories = newState.loadedStories,
               let existingIndex = loadedStories.firstIndex(where: { $0.id == story.id }) {
                loadedStories[existingIndex] = story
                newState.loadedStories = loadedStories
            }
        }
    case .refreshSettings(let settings):
        newState.settingsState = settings
    }
    return newState
}
