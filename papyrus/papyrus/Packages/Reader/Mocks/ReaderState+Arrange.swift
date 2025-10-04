//
//  ReaderState+Arrange.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Reader
import Settings
import TextGeneration

public extension ReaderState {
    static var arrange: ReaderState {
        arrange()
    }
    
    static func arrange(
        mainCharacter: String = "",
        setting: String = "",
        loadedStories: [Story] = [],
        story: Story? = nil,
        sequelStory: Story? = nil,
        isLoading: Bool = false,
        loadingStep: LoadingStep = .idle,
        settingsState: SettingsState = SettingsState(),
        showStoryForm: Bool = false,
        showSubscriptionSheet: Bool = false
    ) -> ReaderState {
        .init(
            mainCharacter: mainCharacter,
            setting: setting,
            loadedStories: loadedStories,
            story: story,
            sequelStory: sequelStory,
            isLoading: isLoading,
            loadingStep: loadingStep,
            settingsState: settingsState,
            showStoryForm: showStoryForm,
            showSubscriptionSheet: showSubscriptionSheet
        )
    }
}
