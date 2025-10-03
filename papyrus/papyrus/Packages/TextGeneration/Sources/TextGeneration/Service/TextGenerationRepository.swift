//
//  TextGenerationRepository.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import Foundation

protocol TextGenerationRepositoryProtocol {
    func createPlotOutline(story originalStory: Story) async throws -> Story
    func createSequelPlotOutline(story originalStory: Story, previousStory: Story) async throws -> Story
    func createChapterBreakdown(story originalStory: Story) async throws -> Story
    func getStoryDetails(story originalStory: Story) async throws -> Story
    func getChapterTitle(story originalStory: Story) async throws -> Story
    func createChapter(story originalStory: Story) async throws -> Story
}

public class TextGenerationRepository: TextGenerationRepositoryProtocol {
    private let apiURL = "https://openrouter.ai/api/v1/chat/completions"
    let apiKey = "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"
    
    public init() {

    }
    
    public func createPlotOutline(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a creative story planner. Create a compelling plot outline for a story."
                ],
                [
                    "role": "user",
                    "content": """
You are an expert storyteller and narrative designer with deep knowledge of classic and modern storytelling techniques, including the hero's journey, three-act structure, and principles from Joseph Campbell, Robert McKee, and Syd Field. Your goal is to create a compelling, original plot outline for a story based on the provided setting and main character.

**Context Provided:**
- **Setting:** \(story.setting)
- **Main Character:** \(story.mainCharacter)

**Task:**
Develop a high-quality plot outline that integrates the setting and main character seamlessly. The outline should be original, engaging, and emotionally resonant, with clear stakes, escalating conflict, and satisfying resolution. Aim for a story length equivalent to a novel (around 200,000-250,000 words if written out).

Generate the plot outline now, ensuring it's polished, professional, and ready to inspire a full story.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
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
        
        story.plotOutline = content
        
        return story
    }
    
    public func createSequelPlotOutline(story originalStory: Story, previousStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Get the previous story's chapters for context
        let previousChaptersText = previousStory.chapters
            .enumerated()
            .map { index, chapter in
                "Chapter \(index + 1):\n\(chapter.content)"
            }
            .joined(separator: "\n\n")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a creative story planner specializing in creating sequels. Create a compelling sequel plot outline that builds upon the previous story while introducing fresh conflicts and character development."
                ],
                [
                    "role": "user",
                    "content": """
You are an expert storyteller and narrative designer with deep knowledge of classic and modern storytelling techniques, including the hero's journey, three-act structure, and principles from Joseph Campbell, Robert McKee, and Syd Field. Your goal is to create a compelling, original plot outline for a story sequel based on the provided context, setting and main character.

**Previous Story Context:**
- **Setting:** \(previousStory.setting)
- **Main Character:** \(previousStory.mainCharacter)
- **Previous Plot Outline:** \(previousStory.plotOutline)
- **Previous Story Chapters:** \(previousChaptersText)

**New Sequel Context:**
- **Setting:** \(story.setting)
- **Main Character:** \(story.mainCharacter)

**Task:**
Develop a high-quality sequel plot outline that integrates the setting and main character seamlessly. The outline should be original, engaging, and emotionally resonant, with clear stakes, escalating conflict, and satisfying resolution. Aim for a story length equivalent to a novel (around 200,000-250,000 words if written out).

Generate the sequel plot outline now, ensuring it creates a worthy continuation of the story.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
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
        
        story.plotOutline = content
        
        return story
    }
    
    public func createChapterBreakdown(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a story structure expert. Create a detailed chapter breakdown for a story."
                ],
                [
                    "role": "user",
                    "content": """
You are an expert narrative architect and editor with extensive experience in breaking down stories into chapters, drawing from techniques in books like "Save the Cat" by Blake Snyder, "Story Genius" by Lisa Cron, and "The Anatomy of Story" by John Truby. Your goal is to create a detailed, high-quality chapter breakdown for a story based on the provided plot outline. This breakdown will serve as a blueprint for writing, ensuring smooth pacing, escalating tension, and deep character immersion.

**Context Provided:**
- **Plot Outline:** \(story.plotOutline)

**Task:**
Expand the plot outline into a chapter-by-chapter breakdown for a complete story. Aim for 40-55 chapters to fit a novel-length narrative (200,000-250,000 words), distributing chapters logically across the three acts (e.g., 10-15 in Act 1, 23-25 in Act 2, 7-10 in Act 3). Each chapter must stand alone in the breakdown with its own dedicated outline—no grouping chapters into ranges (e.g., avoid "Chapters 5-7"; treat each as "Chapter 5," "Chapter 6," etc.). Ensure the breakdown faithfully adapts the plot outline while adding granular details like key scenes, character arcs, dialogue hooks, and sensory elements to make it vivid and actionable.

Generate the chapter breakdown now, ensuring it's polished, immersive, and optimized for writing a gripping story.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
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
        
        story.chaptersBreakdown = content
        
        return story
    }
    
    public func getStoryDetails(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a story analysis expert. Count the total number of chapters in a chapter breakdown and return only the integer number."
                ],
                [
                    "role": "user",
                    "content": """
Analyze the following chapter breakdown and return ONLY the total number of chapters as an integer (e.g., just "12" or "15"):

Chapter Breakdown:
\(story.chaptersBreakdown)
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
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
        
        // Extract the integer from the response
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if let numberOfChapters = Int(trimmedContent) {
            story.maxNumberOfChapters = numberOfChapters
        } else {
            // Fallback: try to extract first number from the response
            let numbers = trimmedContent.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Int($0) }
            story.maxNumberOfChapters = numbers.first ?? 0
        }
        
        return story
    }
    
    public func getChapterTitle(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a creative story titling expert. Generate a compelling title for a story based on its details."
                ],
                [
                    "role": "user",
                    "content": """
Based on the following story details, respond with the story title:

**Plot Outline:** \(story.plotOutline)
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
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
        
        story.title = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return story
    }
    
    public func createChapter(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let currentChapterNumber = story.chapters.count + 1
        
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are an acclaimed novelist and creative writing expert, with a mastery of prose craft honed from studying masters like George R.R. Martin, Toni Morrison, and Neil Gaiman, as well as techniques from \"The Emotional Craft of Fiction\" by Donald Maass and \"Writing the Breakout Novel\" by Donald Maass. Your goal is to write a single, high-quality chapter of a story, seamlessly continuing from previous chapters while adhering precisely to the provided chapter breakdown. The result should be immersive, professional-grade narrative prose that captivates readers with vivid language, emotional depth, and tight plotting."
                ],
                [
                    "role": "user",
                    "content": """
**Context Provided:**
- **Full Plot Outline:** \(story.plotOutline)
- **Full Chapter Breakdown:** \(story.chaptersBreakdown)
- **Chapter Number to Write:** Chapter \(currentChapterNumber). Focus exclusively on this one chapter—do not write or summarize others.
- **Previous Written Chapters:** \(story.chapters.reduce("") { $0 + "\n\n" + $1.content })

Write the full chapter text now, ensuring it's a standalone masterpiece that honors the story's vision and leaves readers eager for more.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
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
