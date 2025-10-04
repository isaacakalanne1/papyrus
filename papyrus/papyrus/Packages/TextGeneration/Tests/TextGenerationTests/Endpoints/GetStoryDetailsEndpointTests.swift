//
//  GetStoryDetailsEndpointTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import SDNetworkCore
@testable import TextGeneration

class GetStoryDetailsEndpointTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func initialization() {
        let story = Story(chaptersBreakdown: "Chapter 1: The Beginning\nChapter 2: The Middle")
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
        #expect(endpoint.story.chaptersBreakdown == "Chapter 1: The Beginning\nChapter 2: The Middle")
    }
    
    // MARK: - Path Tests
    
    @Test
    func path() {
        let story = Story()
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
        #expect(endpoint.path == "/api/v1/chat/completions")
    }
    
    // MARK: - Body Tests
    
    @Test
    func body_createsValidData() {
        let story = Story(chaptersBreakdown: "Chapter 1: Introduction\nChapter 2: Development")
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
        let bodyData = endpoint.body
        
        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }
    
    @Test
    func body_containsCorrectJSON() throws {
        let chaptersBreakdown = "Chapter 1: The Quest Begins\nChapter 2: Meeting Allies\nChapter 3: First Challenge"
        let story = Story(chaptersBreakdown: chaptersBreakdown)
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
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
        #expect(systemContent?.contains("story analysis expert") == true)
        #expect(systemContent?.contains("Count the total number of chapters") == true)
        #expect(systemContent?.contains("return only the integer number") == true)
        
        // Verify user message
        let userMessage = messages?[1]
        #expect(userMessage?["role"] as? String == "user")
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains(chaptersBreakdown) == true)
        #expect(userContent?.contains("Chapter Breakdown:") == true)
        #expect(userContent?.contains("ONLY the total number of chapters as an integer") == true)
    }
    
    @Test
    func body_includesChaptersBreakdownInUserMessage() throws {
        let chaptersBreakdown = "Chapter 1: Opening Scene\nChapter 2: Character Development\nChapter 3: Plot Twist\nChapter 4: Climax\nChapter 5: Resolution"
        let story = Story(chaptersBreakdown: chaptersBreakdown)
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        #expect(userContent?.contains(chaptersBreakdown) == true)
    }
    
    @Test
    func body_handlesEmptyChaptersBreakdown() throws {
        let story = Story(chaptersBreakdown: "")
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        
        #expect(messages?.count == 2)
        
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains("Chapter Breakdown:") == true)
    }
    
    @Test
    func body_containsSpecificInstructions() throws {
        let story = Story(chaptersBreakdown: "Test breakdown")
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify specific instructions for integer-only response
        #expect(userContent?.contains("return ONLY the total number") == true)
        #expect(userContent?.contains("as an integer") == true)
        #expect(userContent?.contains("(e.g., just \"12\" or \"15\")") == true)
    }
    
    @Test
    func body_doesNotIncludeReasoning() throws {
        let story = Story(chaptersBreakdown: "Test breakdown")
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        
        // Verify reasoning is not included (nil should not appear in JSON)
        #expect(json?["reasoning"] == nil)
    }
    
    // MARK: - Response Type Tests
    
    @Test
    func responseType() {
        let story = Story()
        let endpoint = GetStoryDetailsEndpoint(story: story)
        
        // This test verifies the response type is correctly defined
        let _: OpenRouterResponse.Type = GetStoryDetailsEndpoint.Response.self
        
        // Test passes if compilation succeeds
        #expect(true)
    }
}
