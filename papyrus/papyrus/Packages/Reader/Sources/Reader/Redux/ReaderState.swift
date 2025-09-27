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

    public init(
        mainCharacter: String = "",
        setting: String = "",
        story: Story? = nil
    ) {
        self.story = story
        self.mainCharacter = mainCharacter
        self.setting = setting
    }
}
