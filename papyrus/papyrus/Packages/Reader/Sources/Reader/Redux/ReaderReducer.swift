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
    case .beginCreateStory:
        newState.isLoading = true
        newState.showStoryForm = false
        newState.loadingStep = .identifyingTheme
        newState.story = .init(
            mainCharacter: newState.mainCharacter,
            setting: newState.setting
        )
    case .beginCreateSequel:
        newState.isLoading = true
        newState.showStoryForm = false
        newState.loadingStep = .identifyingTheme

        newState.sequelStory = newState.story
        newState.sequelStory?.id = UUID()
        newState.sequelStory?.mainCharacter = newState.mainCharacter
        newState.sequelStory?.setting = newState.setting
        newState.sequelStory?.chapters = []
        newState.sequelStory?.chapterIndex = 0
        if let prequelId = newState.story?.id {
            newState.sequelStory?.prequelIds.append(prequelId)
        }
    case .createStoryTheme:
        newState.isLoading = true
        newState.loadingStep = .identifyingTheme
    case .onCreatedThemeDescription(let story):
        newState.isLoading = true // Keep loading for next step
        // Update the story with theme
        if newState.story?.id == story.id {
            newState.story = story
        } else if newState.sequelStory?.id == story.id {
            newState.sequelStory = story
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
    case .onCreatedChapter(var story):
        // Only update the story if current story is nil
        if newState.story?.id == story.id {
            newState.story = story
        }
        newState.isLoading = false
        newState.loadingStep = .idle
        // Update the story in loadedStories if it exists, or add it if not present
        if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
            // Update existing story
            newState.loadedStories[existingIndex] = story
        } else {
            // Add new story if not present
            newState.loadedStories.append(story)
        }
    case .updateMainCharacter(let mainCharacter):
        newState.mainCharacter = mainCharacter
    case .updateSetting(let setting):
        newState.setting = setting
    case .beginCreateChapter:
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
    case .onDeletedStory(let deletedStoryId):
        // Remove the deleted story from loadedStories
        newState.loadedStories.removeAll { $0.id == deletedStoryId }
        // If the currently viewed story was deleted, clear it
        if newState.story?.id == deletedStoryId {
            newState.story = nil
        }
    case .updateChapterIndex(let story, let index):
        var updatedStory = story
        updatedStory.scrollOffset = 0
        updatedStory.chapterIndex = max(0, min(index, story.chapters.count - 1))
        
        // Update the current story if it matches
        if newState.story?.id == story.id {
            newState.story = updatedStory
        }
        
        // Update the story in loadedStories as well
        if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
            newState.loadedStories[existingIndex] = updatedStory
        } else {
            // Add to loadedStories if not present
            newState.loadedStories.append(updatedStory)
        }
    case .updateScrollOffset(let offset):
        if var story = newState.story {
            story.scrollOffset = offset
            newState.story = story
            
            // Update the story in loadedStories as well
            if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
                newState.loadedStories[existingIndex] = story
            }
        }
    case .refreshSettings(let settings):
        newState.settingsState = settings
    case .setShowStoryForm(let show):
        newState.showStoryForm = show
    case .setShowSubscriptionSheet(let show):
        newState.showSubscriptionSheet = show
    case .setSelectedStoryForDetails(let story):
        newState.selectedStoryForDetails = story
    case .setFocusedField(let field):
        newState.focusedField = field
    case .saveStory,
            .deleteStory,
            .loadSubscriptions,
            .createStory,
            .createSequel,
            .createChapter,
            .createStoryTheme,
            .onCreatedThemeDescription:
        break
    }
    return newState
}
