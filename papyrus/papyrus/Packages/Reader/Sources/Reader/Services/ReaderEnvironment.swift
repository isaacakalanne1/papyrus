//
//  ReaderEnvironment.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import TextGeneration

public protocol ReaderEnvironmentProtocol {
    func createChapter(story: Story) async throws -> Story
    func saveStory(_ story: Story) async throws
}

public struct ReaderEnvironment: ReaderEnvironmentProtocol {
    private let textGenerationEnvironment: TextGenerationEnvironmentProtocol
    private let dataStore: ReaderDataStoreProtocol
    
    public init(
        textGenerationEnvironment: TextGenerationEnvironmentProtocol
    ) {
        self.textGenerationEnvironment = textGenerationEnvironment
        self.dataStore = ReaderDataStore()
    }
    
    public func createChapter(story: Story) async throws -> Story {
        try await textGenerationEnvironment.createChapter(story: story)
    }
    
    public func saveStory(_ story: Story) async throws {
        
    }
}
