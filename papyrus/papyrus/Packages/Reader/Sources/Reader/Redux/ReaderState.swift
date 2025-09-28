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

    public init(
        mainCharacter: String = "",
        setting: String = "",
        loadedStories: [Story]? = nil,
        story: Story? = nil,
        isLoading: Bool = false
    ) {
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.loadedStories = loadedStories
        self.story = story
        self.isLoading = isLoading
    }
}
