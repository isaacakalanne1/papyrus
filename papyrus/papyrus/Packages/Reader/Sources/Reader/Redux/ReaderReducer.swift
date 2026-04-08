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

    // MARK: - Story Creation Pipeline Steps

    case .beginCreateStory:
        newState.isLoading = true
        newState.showStoryForm = false
        newState.isSequelMode = false
        newState.loadingStep = .identifyingTheme
        newState.story = .init(
            mainCharacter: newState.mainCharacter,
            setting: newState.setting,
            perspective: newState.settingsState.perspective
        )

    case .beginCreateInteractiveStory:
        newState.isLoading = true
        newState.showStoryForm = false
        newState.isSequelMode = false
        newState.loadingStep = .writingChapter
        newState.story = .init(
            mainCharacter: newState.mainCharacter,
            setting: newState.setting,
            perspective: newState.settingsState.perspective,
            mode: .interactive
        )

    case .onGeneratedFirstParagraph(let story):
        newState.isLoading = false
        newState.loadingStep = .idle
        newState = updateStoryInState(newState, story: story)

    case .submitInteractiveAction:
        newState.isLoading = true
        newState.undoneChapters = []

    case .undoInteractiveChapter:
        guard let last = newState.story?.chapters.last,
              (newState.story?.chapters.count ?? 0) > 1 else { break }
        newState.story?.chapters.removeLast()
        newState.undoneChapters.append(last)
        if case .next(let text) = last.action {
            newState.interactiveInputText = text
        } else {
            newState.interactiveInputText = ""
        }

    case .redoInteractiveChapter:
        guard let chapter = newState.undoneChapters.popLast() else { break }
        newState.story?.chapters.append(chapter)
        if let next = newState.undoneChapters.last,
           case .next(let text) = next.action {
            newState.interactiveInputText = text
        } else {
            newState.interactiveInputText = ""
        }

    case .beginGenerateParagraph(let story):
        newState.isLoading = true
        newState.loadingStep = .writingChapter
        newState = updateStoryInState(newState, story: story)

    case .onGeneratedParagraph(let story):
        newState.isLoading = false
        newState.loadingStep = .idle
        newState.interactiveInputText = ""
        newState = updateStoryInState(newState, story: story)

    case .setInteractiveMode(let mode):
        newState.settingsState.storyMode = mode

    case .setInteractiveInputText(let text):
        newState.interactiveInputText = text


    case .generateFirstParagraph:
        break

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
        newState.sequelStory?.perspective = newState.settingsState.perspective
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

    case .getChapterTitle:
        newState.isLoading = true
        newState.loadingStep = .preparingNarrative

    case .onGetChapterTitle(let story):
        newState = updateStoryInState(newState, story: story)
        if story.mode == .interactive {
            newState.isLoading = false
            newState.loadingStep = .idle
        } else {
            newState.isLoading = true
        }

    case .beginCreateChapter(let story):
        newState.isLoading = true
        newState.loadingStep = .writingChapter
        newState = updateStoryInState(newState, story: story)

    case .onCreatedChapter(let story):
        newState.isLoading = false
        newState.loadingStep = .idle
        newState.failedGenerationAction = nil
        newState = updateStoryInState(newState, story: story)

    case .failedToCreateChapter(let retryAction):
        newState.isLoading = false
        newState.loadingStep = .idle
        newState.failedGenerationAction = retryAction

    case .dismissGenerationError:
        newState.failedGenerationAction = nil

    case .retryGeneration(_):
        newState.failedGenerationAction = nil
        newState.isLoading = true
        newState.loadingStep = .preparing

    // MARK: - Story Management

    case .updateMainCharacter(let mainCharacter):
        newState.mainCharacter = mainCharacter

    case .updateSetting(let setting):
        newState.setting = setting

    case .updatePerspective(let p):
        newState.settingsState.perspective = p

    case .setSentenceCount(let count):
        newState.settingsState.sentenceCount = count

    case .updateStoryTitle(let story, let title):
        if newState.story?.id == story.id {
            newState.story?.title = title
        }
        if let index = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
            newState.loadedStories[index].title = title
        }
        if newState.selectedStoryForDetails?.id == story.id {
            newState.selectedStoryForDetails?.title = title
        }

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
        newState.undoneChapters = []

    case .confirmDeleteStory(let story):
        newState.storyPendingDeletion = story

    case .cancelDeleteStory:
        newState.storyPendingDeletion = nil

    case .onDeletedStory(let deletedStoryId):
        newState.loadedStories.removeAll { $0.id == deletedStoryId }
        if newState.story?.id == deletedStoryId {
            newState.story = nil
        }
        newState.storyPendingDeletion = nil

    case .updateChapterIndex(let story, let index):
        var updatedStory = story
        updatedStory.scrollOffset = 0
        updatedStory.chapterIndex = max(0, min(index, story.chapters.count - 1))
        newState.currentScrollOffset = 0
        newState = updateStoryInState(newState, story: updatedStory)

    case .updateScrollOffset(let offset):
        if var story = newState.story {
            story.scrollOffset = offset
            newState = updateStoryInState(newState, story: story)
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

    case .reuseStoryDetails(let story):
        newState.mainCharacter = story.mainCharacter
        newState.setting = story.setting
        newState.settingsState.perspective = story.perspective
        newState.settingsState.storyMode = story.mode
        newState.selectedStoryForDetails = nil
        newState.showStoryForm = true

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
         .createStory,
         .createInteractiveStory,
         .createSequel,
         .createChapter,
         .failedToDeleteStory,
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
    if let existingIndex = newState.loadedStories.firstIndex(where: { $0.id == story.id }) {
        newState.loadedStories[existingIndex] = story
    } else {
        newState.loadedStories.append(story)
    }
    return newState
}
