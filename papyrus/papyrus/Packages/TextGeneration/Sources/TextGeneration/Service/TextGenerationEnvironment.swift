//
//  TextGenerationEnvironment.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 27/09/2025.
//

public protocol TextGenerationEnvironmentProtocol {
    func createChapter() async throws -> String
}

public struct TextGenerationEnvironment: TextGenerationEnvironmentProtocol {
    private let repository: TextGenerationRepositoryProtocol
    
    public init() {
        self.repository = TextGenerationRepository()
    }
    
    public func createChapter() async throws -> String {
        try await repository.createChapter()
    }
}
