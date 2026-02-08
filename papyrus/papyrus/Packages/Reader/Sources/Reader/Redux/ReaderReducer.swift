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
    case .createStory(let step, let story):
        newState.storyCreationStep = step
        
        switch step {
        case .idle:
            newState.isLoading = false
        case .initial:
            newState.isLoading = true
            newState.showStoryForm = false
            newState.isSequelMode = false
            newState.story = .init(
                mainCharacter: newState.mainCharacter,
                setting: newState.setting
            )
            newState.storyCreationStep = .identifyingTheme // Transition to first actual step
        case .sequel:
            newState.isLoading = true
            newState.showStoryForm = false
            newState.isSequelMode = true
            
            newState.sequelStory = newState.story
            newState.sequelStory?.id = UUID()
            newState.sequelStory?.mainCharacter = newState.mainCharacter
            newState.sequelStory?.setting = newState.setting
            newState.sequelStory?.chapters = []
            newState.sequelStory?.chapterIndex = 0
            if let prequelId = newState.story?.id {
                newState.sequelStory?.prequelIds.append(prequelId)
            }
            newState.storyCreationStep = .identifyingTheme // Transition to first actual step
        case .identifyingTheme, .creatingPlotOutline, .creatingChapterBreakdown:
            newState.isLoading = true
        case .gettingStoryDetails:
            newState.isLoading = true
            newState.storyCreationStep = .analyzingStructure // Mapping to legacy LoadingView step
        case .gettingChapterTitle:
            newState.isLoading = true
            newState.storyCreationStep = .preparingNarrative // Mapping to legacy LoadingView step
        case .writingChapter:
            newState.isLoading = true
        case .analyzingStructure, .preparingNarrative:
            newState.isLoading = true
        }
        
        // If a story was provided, update it in the state
        if let story = story {
            if newState.story?.id == story.id {
                newState.story = story
            } else if newState.sequelStory?.id == story.id {
                newState.sequelStory = story
            }
            
            // Update in loadedStories
            if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
                newState.loadedStories[existingIndex] = story
            } else if step == .writingChapter {
                // If it's a new story completion, add it
                newState.loadedStories.append(story)
            }
        }
        
        if step == .idle {
            newState.isLoading = false
        }
        
    case .updateMainCharacter(let mainCharacter):
        newState.mainCharacter = mainCharacter
    case .updateSetting(let setting):
        newState.setting = setting
    case .loadAllStories:
        newState.isLoading = true
    case .onLoadedStories(let stories):
        newState.loadedStories = stories
        newState.isLoading = false
        newState.storyCreationStep = .idle
    case .failedToLoadStories:
        newState.isLoading = false
        newState.storyCreationStep = .idle
    case .setStory(let story):
        newState.story = story
    case .onCreatedStory(let story):
        // Update the story if it matches
        if newState.story?.id == story.id {
            newState.story = story
        }
        newState.isLoading = false
        newState.storyCreationStep = .idle
        // Update in loadedStories
        if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
            newState.loadedStories[existingIndex] = story
        } else {
            newState.loadedStories.append(story)
        }
    case .failedToCreateStory:
        newState.isLoading = false
        newState.storyCreationStep = .idle
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
        newState.isLoading = false
    case .setSelectedStoryForDetails(let story):
        newState.selectedStoryForDetails = story
    case .setFocusedField(let field):
        newState.focusedField = field
    case .setMenuStatus(let status):
        newState.menuStatus = status
    case .setDragOffset(let offset):
        newState.dragOffset = offset
    case .setIsSequelMode(let isSequelMode):
        newState.isSequelMode = isSequelMode
    case .setCurrentScrollOffset(let offset):
        newState.currentScrollOffset = offset
    case .setScrollViewHeight(let height):
        newState.scrollViewHeight = height
    case .saveStory,
            .deleteStory,
            .loadSubscriptions:
        break
    }
    return newState
}
