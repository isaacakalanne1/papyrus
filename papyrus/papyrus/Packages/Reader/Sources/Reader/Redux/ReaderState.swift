//
//  ReaderState.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import TextGeneration

public struct ReaderState: Equatable {
    var mainCharacter: String
    var setting: String
    var loadedStories: [Story]?
    var story: Story?
    var isLoading: Bool
    var loadingStep: LoadingStep

    public init(
        mainCharacter: String = "",
        setting: String = "",
        loadedStories: [Story]? = nil,
        story: Story? = nil,
        isLoading: Bool = false,
        loadingStep: LoadingStep = .idle
    ) {
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.loadedStories = loadedStories
        self.story = story
        self.isLoading = isLoading
        self.loadingStep = loadingStep
    }
}

public enum LoadingStep: Equatable {
    case idle
    case buildingStory
    case refiningDetails
    case expandingNarrative
    case addingDepth
    case finalizingStory
}
