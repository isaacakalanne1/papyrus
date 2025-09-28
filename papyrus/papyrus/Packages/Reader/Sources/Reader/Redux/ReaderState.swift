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
    var story: Story?
    var isLoading: Bool

    public init(
        mainCharacter: String = "",
        setting: String = "",
        story: Story? = nil,
        isLoading: Bool = false
    ) {
        self.story = story
        self.mainCharacter = mainCharacter
        self.setting = setting
        self.isLoading = isLoading
    }
}
