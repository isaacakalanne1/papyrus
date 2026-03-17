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
    case .createStory(let step, let story, _):
        newState.storyCreationStep = step

        switch step {
        case .idle:
            newState.isLoading = false
            newState.loadingDisplayStep = .idle
        case .initial:
            newState.isLoading = true
            newState.loadingDisplayStep = .preparing
            newState.showStoryForm = false
            newState.isSequelMode = false
            newState.story = .init(
                mainCharacter: newState.mainCharacter,
                setting: newState.setting
            )
            newState.storyCreationStep = .identifyingTheme
        case .sequel:
            newState.isLoading = true
            newState.loadingDisplayStep = .preparing
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
            newState.storyCreationStep = .identifyingTheme
        case .identifyingTheme:
            newState.isLoading = true
            newState.loadingDisplayStep = .identifyingTheme
        case .creatingPlotOutline:
            newState.isLoading = true
            newState.loadingDisplayStep = .creatingPlotOutline
        case .creatingChapterBreakdown:
            newState.isLoading = true
            newState.loadingDisplayStep = .creatingChapterBreakdown
        case .gettingStoryDetails:
            newState.isLoading = true
            newState.loadingDisplayStep = .analyzingStructure
        case .gettingChapterTitle:
            newState.isLoading = true
            newState.loadingDisplayStep = .preparingNarrative
        case .writingChapter:
            newState.isLoading = true
            newState.loadingDisplayStep = .writingChapter
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
                newState.loadedStories.append(story)
            }
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
        newState.loadingDisplayStep = .idle
    case .failedToLoadStories:
        newState.isLoading = false
        newState.storyCreationStep = .idle
        newState.loadingDisplayStep = .idle
    case .setStory(let story):
        newState.story = story
        newState.currentScrollOffset = story?.scrollOffset ?? 0
    case .onCreatedStory(let story, let navigateOnCompletion):
        var updatedStory = story
        if navigateOnCompletion {
            updatedStory.chapterIndex = story.chapters.count - 1
            updatedStory.scrollOffset = 0
            newState.currentScrollOffset = 0
        }
        if newState.story?.id == story.id {
            newState.story = updatedStory
        }
        newState.isLoading = false
        newState.storyCreationStep = .idle
        newState.loadingDisplayStep = .idle
        if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
            newState.loadedStories[existingIndex] = updatedStory
        } else {
            newState.loadedStories.append(updatedStory)
        }
    case .failedToCreateStory:
        newState.isLoading = false
        newState.storyCreationStep = .idle
        newState.loadingDisplayStep = .idle
    case .onDeletedStory(let deletedStoryId):
        newState.loadedStories.removeAll { $0.id == deletedStoryId }
        if newState.story?.id == deletedStoryId {
            newState.story = nil
        }
    case .failedToDeleteStory:
        break
    case .updateChapterIndex(let story, let index):
        var updatedStory = story
        updatedStory.scrollOffset = 0
        updatedStory.chapterIndex = max(0, min(index, story.chapters.count - 1))
        newState.currentScrollOffset = 0

        if newState.story?.id == story.id {
            newState.story = updatedStory
        }

        if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
            newState.loadedStories[existingIndex] = updatedStory
        } else {
            newState.loadedStories.append(updatedStory)
        }
    case .updateScrollOffset(let offset):
        if var story = newState.story {
            story.scrollOffset = offset
            newState.story = story

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
        newState.loadingDisplayStep = .idle
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
