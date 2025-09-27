//
//  ReaderEnvironment.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import TextGeneration

public protocol ReaderEnvironmentProtocol {
    func createChapter(story: Story) async throws -> Story
}

public struct ReaderEnvironment: ReaderEnvironmentProtocol {
    private let textGenerationEnvironment: TextGenerationEnvironmentProtocol
    
    public init(
        textGenerationEnvironment: TextGenerationEnvironmentProtocol
    ) {
        self.textGenerationEnvironment = textGenerationEnvironment
    }
    
    public func createChapter(story: Story) async throws -> Story {
        try await textGenerationEnvironment.createChapter(story: story)
    }
}
