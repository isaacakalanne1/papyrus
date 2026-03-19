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

public enum InteractiveActionMode: Equatable, Sendable {
    case `do`, say, event
}

public enum MenuStatus: Equatable, Sendable {
    case closed
    case storyOpen
    case settingsOpen
}

public enum LoadingStep: Equatable, Sendable {
    case idle
    case preparing
    case identifyingTheme
    case creatingPlotOutline
    case creatingChapterBreakdown
    case analyzingStructure
    case preparingNarrative
    case writingChapter
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

    // Error state: the pipeline action that should be retried on "Try Again"
    var failedGenerationAction: ReaderAction?

    // Deletion confirmation: the story awaiting user confirmation before deletion
    var storyPendingDeletion: Story?

    // Interactive story mode
    var interactiveInputText: String
    var selectedActionMode: InteractiveActionMode

    // UI State
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
        failedGenerationAction: ReaderAction? = nil,
        storyPendingDeletion: Story? = nil,
        interactiveInputText: String = "",
        selectedActionMode: InteractiveActionMode = .do,
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
        self.failedGenerationAction = failedGenerationAction
        self.storyPendingDeletion = storyPendingDeletion
        self.interactiveInputText = interactiveInputText
        self.selectedActionMode = selectedActionMode
        self.menuStatus = menuStatus
        self.dragOffset = dragOffset
        self.isSequelMode = isSequelMode
        self.currentScrollOffset = currentScrollOffset
        self.scrollViewHeight = scrollViewHeight
    }

    // MARK: - Computed Properties

    var contentState: ContentState {
        if let story = story {
            if story.mode == .interactive {
                return .interactiveStory(story)
            } else if !story.chapters.isEmpty,
                      story.chapterIndex < story.chapters.count {
                return .story(story)
            }
        }
        return .welcome
    }

    var canCreateChapter: Bool {
        let isAtFreeLimit = (story?.chapters.count ?? 0) >= 2
        return settingsState.isSubscribed || !isAtFreeLimit
    }

    var canGenerateParagraph: Bool {
        let isAtFreeLimit = (story?.chapters.count ?? 0) >= 20
        return settingsState.isSubscribed || !isAtFreeLimit
    }
}
