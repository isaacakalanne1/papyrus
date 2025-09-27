//
//  TextGenerationRepository.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import Foundation

protocol TextGenerationRepositoryProtocol {
    func createChapter(story originalStory: Story) async throws -> Story
}

public class TextGenerationRepository: TextGenerationRepositoryProtocol {
    private let apiURL = "https://openrouter.ai/api/v1/chat/completions"
    
    public init() {

    }
    
    public func createChapter(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        let apiKey = "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"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a creative story writer. Write the first chapter of an engaging story."
                ],
                [
                    "role": "user",
                    "content": """
Write the \(story.chapters.isEmpty ? "first" : "next") chapter of a captivating story. Include vivid descriptions, interesting characters, and an intriguing premise that will hook readers. The chapter should be around 500 words.
\(story.mainCharacter.isEmpty ? "" : "Main character: \(story.mainCharacter)")
\(story.setting.isEmpty ? "" : "Setting: \(story.setting)")
\(story.chapters.isEmpty ? "" : "Previous chapters: \(story.chapters.reduce("", { $0 + "\n\n" + $1.content }))")
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TextGenerationError.invalidResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw TextGenerationError.parsingError
        }
        
        story.chapters.append(.init(content: content))
        
        return story
    }
}

public enum TextGenerationError: Error {
    case invalidResponse
    case parsingError
}
