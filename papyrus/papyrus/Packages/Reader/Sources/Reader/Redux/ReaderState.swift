//
//  ReaderState.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import TextGeneration

public struct ReaderState: Equatable {
    var story: Story?

    public init(
        story: Story? = nil
    ) {
        self.story = story
    }
}
