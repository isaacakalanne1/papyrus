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

    case let .onGeneratedFirstParagraph(story):
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
        if case let .next(text) = last.action {
            newState.interactiveInputText = text
        } else {
            newState.interactiveInputText = ""
        }

    case .redoInteractiveChapter:
        guard let chapter = newState.undoneChapters.popLast() else { break }
        newState.story?.chapters.append(chapter)
        if let next = newState.undoneChapters.last,
           case let .next(text) = next.action
        {
            newState.interactiveInputText = text
        } else {
            newState.interactiveInputText = ""
        }

    case let .beginGenerateParagraph(story):
        newState.isLoading = true
        newState.loadingStep = .writingChapter
        newState = updateStoryInState(newState, story: story)

    case let .onGeneratedParagraph(story):
        newState.isLoading = false
        newState.loadingStep = .idle
        newState.interactiveInputText = ""
        newState = updateStoryInState(newState, story: story)

    case let .setInteractiveMode(mode):
        newState.settingsState.storyMode = mode

    case let .setInteractiveInputText(text):
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

    case let .createStoryTheme(story):
        newState.isLoading = true
        newState.loadingStep = .identifyingTheme
        newState = updateStoryInState(newState, story: story)

    case let .onCreatedThemeDescription(story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case let .createPlotOutline(story):
        newState.isLoading = true
        newState.loadingStep = .creatingPlotOutline
        newState = updateStoryInState(newState, story: story)

    case let .onCreatedPlotOutline(story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case let .condensePlotOutline(story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case let .onCondensedPlotOutline(story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case let .createChapterBreakdown(story):
        newState.isLoading = true
        newState.loadingStep = .creatingChapterBreakdown
        newState = updateStoryInState(newState, story: story)

    case let .onCreatedChapterBreakdown(story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case let .parseChapterSummaries(story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case let .onParsedChapterSummaries(story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case let .getStoryDetails(story):
        newState.isLoading = true
        newState.loadingStep = .analyzingStructure
        newState = updateStoryInState(newState, story: story)

    case let .onGetStoryDetails(story):
        newState.isLoading = true
        newState = updateStoryInState(newState, story: story)

    case .getChapterTitle:
        newState.isLoading = true
        newState.loadingStep = .preparingNarrative

    case let .onGetChapterTitle(story):
        newState = updateStoryInState(newState, story: story)
        if story.mode == .interactive {
            newState.isLoading = false
            newState.loadingStep = .idle
        } else {
            newState.isLoading = true
        }

    case let .beginCreateChapter(story):
        newState.isLoading = true
        newState.loadingStep = .writingChapter
        newState = updateStoryInState(newState, story: story)

    case let .onCreatedChapter(story):
        newState.isLoading = false
        newState.loadingStep = .idle
        newState.failedGenerationAction = nil
        newState = updateStoryInState(newState, story: story)

    case let .failedToCreateChapter(retryAction):
        newState.isLoading = false
        newState.loadingStep = .idle
        newState.failedGenerationAction = retryAction

    case .dismissGenerationError:
        newState.failedGenerationAction = nil

    case .retryGeneration:
        newState.failedGenerationAction = nil
        newState.isLoading = true
        newState.loadingStep = .preparing

    // MARK: - Story Management

    case let .updateMainCharacter(mainCharacter):
        newState.mainCharacter = mainCharacter

    case let .updateSetting(setting):
        newState.setting = setting

    case let .updatePerspective(p):
        newState.settingsState.perspective = p

    case let .setSentenceCount(count):
        newState.settingsState.sentenceCount = count

    case let .updateStoryTitle(story, title):
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

    case let .onLoadedStories(stories):
        newState.loadedStories = stories
        newState.isLoading = false
        newState.loadingStep = .idle

    case .failedToLoadStories:
        newState.isLoading = false
        newState.loadingStep = .idle

    case let .setStory(story):
        newState.story = story
        newState.currentScrollOffset = story?.scrollOffset ?? 0
        newState.undoneChapters = []

    case let .confirmDeleteStory(story):
        newState.storyPendingDeletion = story

    case .cancelDeleteStory:
        newState.storyPendingDeletion = nil

    case let .onDeletedStory(deletedStoryId):
        newState.loadedStories.removeAll { $0.id == deletedStoryId }
        if newState.story?.id == deletedStoryId {
            newState.story = nil
        }
        newState.storyPendingDeletion = nil

    case let .updateChapterIndex(story, index):
        var updatedStory = story
        updatedStory.scrollOffset = 0
        updatedStory.chapterIndex = max(0, min(index, story.chapters.count - 1))
        newState.currentScrollOffset = 0
        newState = updateStoryInState(newState, story: updatedStory)

    case let .updateScrollOffset(offset):
        if var story = newState.story {
            story.scrollOffset = offset
            newState = updateStoryInState(newState, story: story)
        }

    case let .refreshSettings(settings):
        newState.settingsState = settings

    case let .setShowStoryForm(show):
        newState.showStoryForm = show

    case let .setShowSubscriptionSheet(show):
        newState.showSubscriptionSheet = show
        newState.isLoading = false
        newState.loadingStep = .idle

    case let .setSelectedStoryForDetails(story):
        newState.selectedStoryForDetails = story

    case let .setFocusedField(field):
        newState.focusedField = field

    case let .reuseStoryDetails(story):
        newState.mainCharacter = story.mainCharacter
        newState.setting = story.setting
        newState.settingsState.perspective = story.perspective
        newState.settingsState.storyMode = story.mode
        newState.selectedStoryForDetails = nil
        newState.showStoryForm = true

    case let .setMenuStatus(status):
        newState.menuStatus = status

    case let .setDragOffset(offset):
        newState.dragOffset = offset

    case let .setIsSequelMode(isSequelMode):
        newState.isSequelMode = isSequelMode

    case let .setCurrentScrollOffset(offset):
        newState.currentScrollOffset = offset

    case let .setScrollViewHeight(height):
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
