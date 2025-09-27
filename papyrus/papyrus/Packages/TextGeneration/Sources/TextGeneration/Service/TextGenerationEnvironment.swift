//
//  TextGenerationEnvironment.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

public protocol TextGenerationEnvironmentProtocol {
    func createChapter(story: Story) async throws -> Story
}

public struct TextGenerationEnvironment: TextGenerationEnvironmentProtocol {
    private let repository: TextGenerationRepositoryProtocol
    
    public init() {
        self.repository = TextGenerationRepository()
    }
    
    public func createChapter(story: Story) async throws -> Story {
        try await repository.createChapter(story: story)
    }
}
