//
//  CreateChapterEndpointTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import SDNetworkCore
@testable import TextGeneration

class CreateChapterEndpointTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func initialization() {
        let plotOutline = "A young wizard discovers their true heritage"
        let chaptersBreakdown = "Chapter 1: The revelation\nChapter 2: Training begins"
        let story = Story(plotOutline: plotOutline, chaptersBreakdown: chaptersBreakdown)
        let endpoint = CreateChapterEndpoint(story: story)
        
        #expect(endpoint.story.plotOutline == plotOutline)
        #expect(endpoint.story.chaptersBreakdown == chaptersBreakdown)
    }
    
    // MARK: - Path Tests
    
    @Test
    func path() {
        let story = Story()
        let endpoint = CreateChapterEndpoint(story: story)
        
        #expect(endpoint.path == "/api/v1/chat/completions")
    }
    
    // MARK: - Body Tests
    
    @Test
    func body_createsValidData() {
        let story = Story(plotOutline: "Adventure story", chaptersBreakdown: "Chapter 1: Beginning")
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        
        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }
    
    @Test
    func body_containsCorrectJSON() throws {
        let plotOutline = "Mystery novel about a missing heirloom"
        let chaptersBreakdown = "Chapter 1: The theft\nChapter 2: Investigation"
        let story = Story(plotOutline: plotOutline, chaptersBreakdown: chaptersBreakdown)
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        #expect(json != nil)
        
        // Verify basic structure
        #expect(json?["model"] as? String == "x-ai/grok-4-fast")
        
        let messages = json?["messages"] as? [[String: Any]]
        #expect(messages?.count == 2)
        
        // Verify system message
        let systemMessage = messages?[0]
        #expect(systemMessage?["role"] as? String == "system")
        let systemContent = systemMessage?["content"] as? String
        #expect(systemContent?.contains("acclaimed novelist") == true)
        #expect(systemContent?.contains("creative writing expert") == true)
        
        // Verify user message
        let userMessage = messages?[1]
        #expect(userMessage?["role"] as? String == "user")
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains(plotOutline) == true)
        #expect(userContent?.contains(chaptersBreakdown) == true)
    }
    
    @Test
    func body_includesWritingExpertise() throws {
        let story = Story(plotOutline: "Romance novel")
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let systemMessage = messages?[0]
        let systemContent = systemMessage?["content"] as? String
        
        // Verify writing expertise references
        #expect(systemContent?.contains("George R.R. Martin") == true)
        #expect(systemContent?.contains("Toni Morrison") == true)
        #expect(systemContent?.contains("Neil Gaiman") == true)
        #expect(systemContent?.contains("The Emotional Craft of Fiction") == true)
        #expect(systemContent?.contains("Writing the Breakout Novel") == true)
        #expect(systemContent?.contains("Donald Maass") == true)
    }
    
    @Test
    func body_calculatesCurrentChapterNumber() throws {
        let chapter1 = Chapter(title: "First", content: "Chapter one content")
        let chapter2 = Chapter(title: "Second", content: "Chapter two content")
        let story = Story(chapters: [chapter1, chapter2])
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Should be chapter 3 (existing chapters: 2 + 1)
        #expect(userContent?.contains("**Chapter Number to Write:** Chapter 3") == true)
    }
    
    @Test
    func body_calculatesFirstChapterNumber() throws {
        let story = Story(chapters: []) // No existing chapters
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Should be chapter 1 (no existing chapters + 1)
        #expect(userContent?.contains("**Chapter Number to Write:** Chapter 1") == true)
    }
    
    @Test
    func body_includesPlotOutlineAndBreakdown() throws {
        let plotOutline = "Sci-fi exploration of distant planets"
        let chaptersBreakdown = "Chapter 1: Launch\nChapter 2: First planet\nChapter 3: Alien contact"
        let story = Story(plotOutline: plotOutline, chaptersBreakdown: chaptersBreakdown)
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        #expect(userContent?.contains("**Full Plot Outline:** \(plotOutline)") == true)
        #expect(userContent?.contains("**Full Chapter Breakdown:** \(chaptersBreakdown)") == true)
    }
    
    @Test
    func body_includesPreviousChapters() throws {
        let chapter1 = Chapter(title: "Beginning", content: "Once upon a time in a land far away...")
        let chapter2 = Chapter(title: "Adventure", content: "The hero set off on their quest...")
        let story = Story(chapters: [chapter1, chapter2])
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify previous chapters are included with proper formatting
        #expect(userContent?.contains("**Previous Written Chapters:**") == true)
        #expect(userContent?.contains("Once upon a time in a land far away...") == true)
        #expect(userContent?.contains("The hero set off on their quest...") == true)
    }
    
    @Test
    func body_handlesNoPreviousChapters() throws {
        let story = Story(chapters: [])
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Should still include the section even if empty
        #expect(userContent?.contains("**Previous Written Chapters:**") == true)
    }
    
    @Test
    func body_includesSpecificInstructions() throws {
        let story = Story()
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify specific writing instructions
        #expect(userContent?.contains("Focus exclusively on this one chapter") == true)
        #expect(userContent?.contains("do not write or summarize others") == true)
        #expect(userContent?.contains("standalone masterpiece") == true)
        #expect(userContent?.contains("leaves readers eager for more") == true)
    }
    
    @Test
    func body_includesQualityRequirements() throws {
        let story = Story()
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let systemMessage = messages?[0]
        let systemContent = systemMessage?["content"] as? String
        
        // Verify quality requirements in system message
        #expect(systemContent?.contains("immersive, professional-grade narrative prose") == true)
        #expect(systemContent?.contains("vivid language, emotional depth") == true)
        #expect(systemContent?.contains("tight plotting") == true)
        #expect(systemContent?.contains("captivates readers") == true)
    }
    
    @Test
    func body_handlesEmptyValues() throws {
        let story = Story(plotOutline: "", chaptersBreakdown: "", chapters: [])
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        
        #expect(messages?.count == 2)
        
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains("**Full Plot Outline:**") == true)
        #expect(userContent?.contains("**Full Chapter Breakdown:**") == true)
        #expect(userContent?.contains("**Previous Written Chapters:**") == true)
        #expect(userContent?.contains("**Chapter Number to Write:** Chapter 1") == true)
    }
    
    @Test
    func body_includesReasoning() throws {
        let story = Story()
        let endpoint = CreateChapterEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        
        // Verify reasoning is included
        let reasoning = json?["reasoning"] as? [String: Any]
        #expect(reasoning != nil)
        #expect(reasoning?["max_tokens"] as? Int == 5000)
    }
    
    // MARK: - Response Type Tests
    
    @Test
    func responseType() {
        let story = Story()
        let endpoint = CreateChapterEndpoint(story: story)
        
        // This test verifies the response type is correctly defined
        let _: OpenRouterResponse.Type = CreateChapterEndpoint.Response.self
        
        // Test passes if compilation succeeds
        #expect(true)
    }
}
