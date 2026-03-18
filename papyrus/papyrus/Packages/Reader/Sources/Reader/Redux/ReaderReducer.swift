//
//  ReaderReducer.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import ReduxKit
import TextGeneration

@MainActor
let readerReducer: Reducer<ReaderState, ReaderAction> = { state, action in
    var newState = state
    switch action {

    // MARK: - Story Creation Entry Points (no state change; handled by middleware)
    case .createStory,
         .createSequel,
         .createChapter:
        break

    // MARK: - Story Creation Pipeline Steps

    case .beginCreateStory:
        newState.isLoading = true
        newState.showStoryForm = false
        newState.isSequelMode = false
        newState.loadingStep = .identifyingTheme
        newState.story = .init(
            mainCharacter: newState.mainCharacter,
            setting: newState.setting
        )

    case .beginCreateSequel:
        newState.isLoading = true
        newState.showStoryForm = false
        newState.isSequelMode = true
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

    case .createStoryTheme(let story):
        newState.isLoading = true
        newState.loadingStep = .identifyingTheme
        newState = updateStoryInState(newState, story: story)

    case .onCreatedThemeDescription(let story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case .createPlotOutline(let story):
        newState.isLoading = true
        newState.loadingStep = .creatingPlotOutline
        newState = updateStoryInState(newState, story: story)

    case .onCreatedPlotOutline(let story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case .createChapterBreakdown(let story):
        newState.isLoading = true
        newState.loadingStep = .creatingChapterBreakdown
        newState = updateStoryInState(newState, story: story)

    case .onCreatedChapterBreakdown(let story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case .getStoryDetails(let story):
        newState.isLoading = true
        newState.loadingStep = .analyzingStructure
        newState = updateStoryInState(newState, story: story)

    case .onGetStoryDetails(let story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case .getChapterTitle(let story):
        newState.isLoading = true
        newState.loadingStep = .preparingNarrative
        newState = updateStoryInState(newState, story: story)

    case .onGetChapterTitle(let story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case .beginCreateChapter(let story):
        newState.isLoading = true
        newState.loadingStep = .writingChapter
        newState = updateStoryInState(newState, story: story)

    case .onCreatedChapter(let story):
        newState.isLoading = false
        newState.loadingStep = .idle
        if newState.story?.id == story.id {
            newState.story = story
        }
        if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
            newState.loadedStories[existingIndex] = story
        } else {
            newState.loadedStories.append(story)
        }

    case .failedToCreateChapter:
        newState.isLoading = false
        newState.loadingStep = .idle

    // MARK: - Story Management

    case .updateMainCharacter(let mainCharacter):
        newState.mainCharacter = mainCharacter

    case .updateSetting(let setting):
        newState.setting = setting

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
        newState.currentScrollOffset = story?.scrollOffset ?? 0

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
        newState.loadingStep = .idle

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

// MARK: - Helpers

private func updateStoryInState(_ state: ReaderState, story: Story) -> ReaderState {
    var newState = state
    if newState.story?.id == story.id {
        newState.story = story
    } else if newState.sequelStory?.id == story.id {
        newState.sequelStory = story
    }
    return newState
}
