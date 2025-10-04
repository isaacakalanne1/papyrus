//
//  CreateSequelPlotOutlineEndpointTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import SDNetworkCore
@testable import TextGeneration

class CreateSequelPlotOutlineEndpointTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func initialization() {
        let story = Story(mainCharacter: "Queen Isabella", setting: "New Kingdom")
        let previousStory = Story(mainCharacter: "Princess Isabella", setting: "Old Kingdom")
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        #expect(endpoint.story.setting == "New Kingdom")
        #expect(endpoint.story.mainCharacter == "Queen Isabella")
        #expect(endpoint.previousStory.setting == "Old Kingdom")
        #expect(endpoint.previousStory.mainCharacter == "Princess Isabella")
    }
    
    // MARK: - Path Tests
    
    @Test
    func path() {
        let story = Story()
        let previousStory = Story()
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        #expect(endpoint.path == "/api/v1/chat/completions")
    }
    
    // MARK: - Body Tests
    
    @Test
    func body_createsValidData() {
        let story = Story(mainCharacter: "Commander Sarah", setting: "Space colony")
        let previousStory = Story(mainCharacter: "Lieutenant Sarah", setting: "Earth")
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        let bodyData = endpoint.body
        
        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }
    
    @Test
    func body_containsCorrectJSON() throws {
        let story = Story(mainCharacter: "Hero Alex", setting: "Future world")
        let previousStory = Story(mainCharacter: "Alex", setting: "Present world")
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
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
        #expect(systemContent?.contains("creative story planner specializing in creating sequels") == true)
        #expect(systemContent?.contains("builds upon the previous story") == true)
        
        // Verify user message
        let userMessage = messages?[1]
        #expect(userMessage?["role"] as? String == "user")
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains("Future world") == true)
        #expect(userContent?.contains("Hero Alex") == true)
        #expect(userContent?.contains("Present world") == true)
    }
    
    @Test
    func body_includesPreviousStoryContext() throws {
        let previousSetting = "Ancient Rome"
        let previousCharacter = "Gladiator Marcus"
        let previousPlotOutline = "A gladiator fights for freedom in the arena"
        let previousStory = Story(
            mainCharacter: previousCharacter,
            setting: previousSetting,
            plotOutline: previousPlotOutline
        )
        
        let story = Story(mainCharacter: "Knight Marcus", setting: "Medieval Europe")
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify previous story context is included
        #expect(userContent?.contains("**Previous Story Context:**") == true)
        #expect(userContent?.contains("**Setting:** \(previousSetting)") == true)
        #expect(userContent?.contains("**Main Character:** \(previousCharacter)") == true)
        #expect(userContent?.contains("**Previous Plot Outline:** \(previousPlotOutline)") == true)
    }
    
    @Test
    func body_includesNewSequelContext() throws {
        let newSetting = "Cyberpunk city"
        let newCharacter = "Hacker Nova"
        let story = Story(mainCharacter: newCharacter, setting: newSetting)
        let previousStory = Story(mainCharacter: "Detective Nova", setting: "Old city")
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify new sequel context is included
        #expect(userContent?.contains("**New Sequel Context:**") == true)
        #expect(userContent?.contains("**Setting:** \(newSetting)") == true)
        #expect(userContent?.contains("**Main Character:** \(newCharacter)") == true)
    }
    
    @Test
    func body_includesPreviousChapters() throws {
        let chapter1 = Chapter(title: "Beginning", content: "Once upon a time...")
        let chapter2 = Chapter(title: "Middle", content: "The adventure continues...")
        let previousStory = Story(chapters: [chapter1, chapter2])
        let story = Story()
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify previous chapters are included with proper formatting
        #expect(userContent?.contains("**Previous Story Chapters:**") == true)
        #expect(userContent?.contains("Chapter 1:\nOnce upon a time...") == true)
        #expect(userContent?.contains("Chapter 2:\nThe adventure continues...") == true)
    }
    
    @Test
    func body_handlesEmptyPreviousChapters() throws {
        let previousStory = Story(chapters: [])
        let story = Story()
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Should still include the chapters section even if empty
        #expect(userContent?.contains("**Previous Story Chapters:**") == true)
    }
    
    @Test
    func body_includesStorytellingExpertise() throws {
        let story = Story()
        let previousStory = Story()
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify storytelling expertise references
        #expect(userContent?.contains("Joseph Campbell") == true)
        #expect(userContent?.contains("Robert McKee") == true)
        #expect(userContent?.contains("Syd Field") == true)
        #expect(userContent?.contains("hero's journey") == true)
        #expect(userContent?.contains("three-act structure") == true)
    }
    
    @Test
    func body_includesSequelSpecificRequirements() throws {
        let story = Story()
        let previousStory = Story()
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify sequel-specific requirements
        #expect(userContent?.contains("sequel plot outline") == true)
        #expect(userContent?.contains("worthy continuation of the story") == true)
        #expect(userContent?.contains("200,000-250,000 words") == true)
    }
    
    @Test
    func body_includesReasoning() throws {
        let story = Story()
        let previousStory = Story()
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
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
        let previousStory = Story()
        let endpoint = CreateSequelPlotOutlineEndpoint(story: story, previousStory: previousStory)
        
        // This test verifies the response type is correctly defined
        let _: OpenRouterResponse.Type = CreateSequelPlotOutlineEndpoint.Response.self
        
        // Test passes if compilation succeeds
        #expect(true)
    }
}
