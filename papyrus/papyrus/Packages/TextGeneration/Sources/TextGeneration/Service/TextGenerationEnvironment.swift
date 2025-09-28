//
//  TextGenerationEnvironment.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

public protocol TextGenerationEnvironmentProtocol {
    func createPlotOutline(story: Story) async throws -> Story
    func createChapterBreakdown(story: Story) async throws -> Story
    func getStoryDetails(story: Story) async throws -> Story
    func createChapter(story: Story) async throws -> Story
}

public struct TextGenerationEnvironment: TextGenerationEnvironmentProtocol {
    private let repository: TextGenerationRepositoryProtocol
    
    public init() {
        self.repository = TextGenerationRepository()
    }
    
    public func createPlotOutline(story: Story) async throws -> Story {
        try await repository.createPlotOutline(story: story)
    }
    
    public func createChapterBreakdown(story: Story) async throws -> Story {
        try await repository.createChapterBreakdown(story: story)
    }
    
    public func getStoryDetails(story: Story) async throws -> Story {
        try await repository.getStoryDetails(story: story)
    }
    
    public func createChapter(story: Story) async throws -> Story {
        try await repository.createChapter(story: story)
    }
}
