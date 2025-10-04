//
//  ReaderState.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import TextGeneration
import Settings

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
    var isMenuOpen: Bool
    var isSettingsOpen: Bool

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
        isMenuOpen: Bool = false,
        isSettingsOpen: Bool = false
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
        self.isMenuOpen = isMenuOpen
        self.isSettingsOpen = isSettingsOpen
    }
    
    // Computed property to check if user can create more chapters
    var canCreateChapter: Bool {
        guard let story = story else { return true }
        // Allow creation if user is subscribed OR if story has fewer than 2 chapters
        return settingsState.isSubscribed || story.chapters.count < 2
    }
}

public enum LoadingStep: Equatable {
    case idle
    case creatingPlotOutline    // Step 1: Creating the overall story plot
    case creatingChapterBreakdown // Step 2: Breaking down into chapters
    case analyzingStructure     // Step 3: Analyzing story structure
    case preparingNarrative     // Step 4: Preparing for narration
    case writingChapter         // Separate state for writing individual chapters
}
