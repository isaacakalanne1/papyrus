//
//  ReaderState.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import TextGeneration
import Settings

public enum ReaderField: Equatable, Sendable {
    case mainCharacter
    case settingDetails
}

public enum MenuStatus: Equatable, Sendable {
    case closed
    case storyOpen
    case settingsOpen
}

public struct ReaderState: Equatable {
    var mainCharacter: String
    var setting: String
    var loadedStories: [Story]
    var story: Story?
    var sequelStory: Story?
    var isLoading: Bool
    var storyCreationStep: StoryCreationStep
    var settingsState: SettingsState
    var showStoryForm: Bool
    var showSubscriptionSheet: Bool
    var selectedStoryForDetails: Story?
    var focusedField: ReaderField?
    
    // UI State moved from ReaderView
    var menuStatus: MenuStatus
    var dragOffset: CGFloat
    var isSequelMode: Bool
    var currentScrollOffset: CGFloat
    var scrollViewHeight: CGFloat
    var shouldNavigateAfterChapterCreation: Bool

    public init(
        mainCharacter: String = "",
        setting: String = "",
        loadedStories: [Story] = [],
        story: Story? = nil,
        sequelStory: Story? = nil,
        isLoading: Bool = false,
        storyCreationStep: StoryCreationStep = .idle,
        settingsState: SettingsState = SettingsState(),
        showStoryForm: Bool = false,
        showSubscriptionSheet: Bool = false,
        selectedStoryForDetails: Story? = nil,
        focusedField: ReaderField? = nil,
        menuStatus: MenuStatus = .closed,
        dragOffset: CGFloat = 0,
        isSequelMode: Bool = false,
        currentScrollOffset: CGFloat = 0,
        scrollViewHeight: CGFloat = 0,
        shouldNavigateAfterChapterCreation: Bool = false
    ) {
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.loadedStories = loadedStories
        self.story = story
        self.sequelStory = sequelStory
        self.isLoading = isLoading
        self.storyCreationStep = storyCreationStep
        self.settingsState = settingsState
        self.showStoryForm = showStoryForm
        self.showSubscriptionSheet = showSubscriptionSheet
        self.selectedStoryForDetails = selectedStoryForDetails
        self.focusedField = focusedField
        self.menuStatus = menuStatus
        self.dragOffset = dragOffset
        self.isSequelMode = isSequelMode
        self.currentScrollOffset = currentScrollOffset
        self.scrollViewHeight = scrollViewHeight
        self.shouldNavigateAfterChapterCreation = shouldNavigateAfterChapterCreation
    }
    
    // Computed property for content state
    var contentState: ContentState {
        if let story = story,
           !story.chapters.isEmpty,
           story.chapterIndex < story.chapters.count {
            return .story(story)
        } else {
            return .welcome
        }
    }
}

public enum StoryCreationStep: Equatable, Sendable {
    case idle
    case initial
    case sequel
    case identifyingTheme
    case creatingPlotOutline
    case creatingChapterBreakdown
    case gettingStoryDetails
    case gettingChapterTitle
    case writingChapter
    
    // Legacy cases from LoadingStep (keeping for now to avoid compilation errors during refactor if used elsewhere)
    case analyzingStructure
    case preparingNarrative
}
