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
    var loadingStep: LoadingStep
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

    public init(
        mainCharacter: String = "",
        setting: String = "",
        loadedStories: [Story] = [],
        story: Story? = nil,
        sequelStory: Story? = nil,
        isLoading: Bool = false,
        loadingStep: LoadingStep = .idle,
        settingsState: SettingsState = SettingsState(),
        showStoryForm: Bool = false,
        showSubscriptionSheet: Bool = false,
        selectedStoryForDetails: Story? = nil,
        focusedField: ReaderField? = nil,
        menuStatus: MenuStatus = .closed,
        dragOffset: CGFloat = 0,
        isSequelMode: Bool = false,
        currentScrollOffset: CGFloat = 0,
        scrollViewHeight: CGFloat = 0
    ) {
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.loadedStories = loadedStories
        self.story = story
        self.sequelStory = sequelStory
        self.isLoading = isLoading
        self.loadingStep = loadingStep
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
    }
    
    // Computed property to check if user can create more chapters
    var canCreateChapter: Bool {
        guard let story = story else { return true }
        // Allow creation if user is subscribed OR if story has fewer than 2 chapters
        return settingsState.isSubscribed || story.chapters.count < 2
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

public enum LoadingStep: Equatable, Sendable {
    case idle
    case identifyingTheme       // Step 1: Identifying story theme
    case creatingPlotOutline    // Step 2: Creating the overall story plot
    case creatingChapterBreakdown // Step 3: Breaking down into chapters
    case analyzingStructure     // Step 4: Analyzing story structure
    case preparingNarrative     // Step 5: Preparing for narration
    case writingChapter         // Separate state for writing individual chapters
}
