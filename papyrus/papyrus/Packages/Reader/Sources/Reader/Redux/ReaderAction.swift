//
//  ReaderAction.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import TextGeneration
import Settings

public indirect enum ReaderAction: Equatable, Sendable {
    // MARK: - Story Creation Entry Points (subscription gate lives here)
    case createStory
    case createInteractiveStory
    case createSequel
    case createChapter(Story)

    // MARK: - Story Creation Pipeline Steps
    case beginCreateStory
    case beginCreateInteractiveStory
    case generateFirstParagraph(Story)
    case onGeneratedFirstParagraph(Story)
    case submitInteractiveAction(Story, ChapterAction?)
    case beginGenerateParagraph(Story)
    case onGeneratedParagraph(Story)
    case setInteractiveMode(StoryMode)
    case setInteractiveInputText(String)
    case undoInteractiveChapter
    case redoInteractiveChapter

    case beginCreateSequel
    case createStoryTheme(Story)
    case onCreatedThemeDescription(Story)
    case createPlotOutline(Story)
    case onCreatedPlotOutline(Story)
    case createChapterBreakdown(Story)
    case onCreatedChapterBreakdown(Story)
    case getStoryDetails(Story)
    case onGetStoryDetails(Story)
    case getChapterTitle(Story)
    case onGetChapterTitle(Story)
    case beginCreateChapter(Story)
    case onCreatedChapter(Story)
    case failedToCreateChapter(ReaderAction)
    case dismissGenerationError
    case retryGeneration(ReaderAction)

    // MARK: - Story Management
    case loadAllStories
    case onLoadedStories([Story])
    case failedToLoadStories
    case setStory(Story?)
    case confirmDeleteStory(Story)
    case cancelDeleteStory
    case deleteStory(UUID)
    case onDeletedStory(UUID)
    case failedToDeleteStory(UUID)

    // MARK: - Story Properties
    case updateMainCharacter(String)
    case updateSetting(String)
    case updatePerspective(StoryPerspective)
    case updateStoryTitle(Story, String)
    case updateChapterIndex(Story, Int)
    case updateScrollOffset(CGFloat)
    case saveStory(Story)
    case refreshSettings(SettingsState)
    case setShowStoryForm(Bool)
    case setShowSubscriptionSheet(Bool)
    case loadSubscriptions
    case setSelectedStoryForDetails(Story?)
    case setFocusedField(ReaderField?)
    case reuseStoryDetails(Story)

    // MARK: - UI State Actions
    case setMenuStatus(MenuStatus)
    case setDragOffset(CGFloat)
    case setIsSequelMode(Bool)
    case setCurrentScrollOffset(CGFloat)
    case setScrollViewHeight(CGFloat)
}
