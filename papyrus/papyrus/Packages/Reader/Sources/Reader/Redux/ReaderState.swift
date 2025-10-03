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

    public init(
        mainCharacter: String = "",
        setting: String = "",
        loadedStories: [Story] = [],
        story: Story? = nil,
        sequelStory: Story? = nil,
        isLoading: Bool = false,
        loadingStep: LoadingStep = .idle,
        settingsState: SettingsState = SettingsState()
    ) {
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.loadedStories = loadedStories
        self.story = story
        self.sequelStory = sequelStory
        self.isLoading = isLoading
        self.loadingStep = loadingStep
        self.settingsState = settingsState
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
