//
//  CreatePlotOutlineEndpointTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import SDNetworkCore
@testable import TextGeneration

class CreatePlotOutlineEndpointTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func initialization() {
        let story = Story(mainCharacter: "Detective Holmes", setting: "Victorian London")
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
        #expect(endpoint.story.setting == "Victorian London")
        #expect(endpoint.story.mainCharacter == "Detective Holmes")
    }
    
    // MARK: - Path Tests
    
    @Test
    func path() {
        let story = Story()
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
        #expect(endpoint.path == "/api/v1/chat/completions")
    }
    
    // MARK: - Body Tests
    
    @Test
    func body_createsValidData() {
        let story = Story(mainCharacter: "Captain Sarah", setting: "Space station")
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
        let bodyData = endpoint.body
        
        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }
    
    @Test
    func body_containsCorrectJSON() throws {
        let story = Story(mainCharacter: "Knight Arthur", setting: "Medieval castle")
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
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
        #expect(systemContent?.contains("creative story planner") == true)
        #expect(systemContent?.contains("compelling plot outline") == true)
        
        // Verify user message
        let userMessage = messages?[1]
        #expect(userMessage?["role"] as? String == "user")
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains("Medieval castle") == true)
        #expect(userContent?.contains("Knight Arthur") == true)
    }
    
    @Test
    func body_includesStorytellingExpertise() throws {
        let story = Story(mainCharacter: "Hacker Alex", setting: "Future city")
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
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
    func body_includesSettingAndCharacter() throws {
        let setting = "Post-apocalyptic wasteland"
        let mainCharacter = "Survivor Maya"
        let story = Story(mainCharacter: mainCharacter, setting: setting)
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        #expect(userContent?.contains("**Setting:** \(setting)") == true)
        #expect(userContent?.contains("**Main Character:** \(mainCharacter)") == true)
    }
    
    @Test
    func body_includesQualityRequirements() throws {
        let story = Story(mainCharacter: "Student Luna", setting: "Magic academy")
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify quality requirements
        #expect(userContent?.contains("original, engaging, and emotionally resonant") == true)
        #expect(userContent?.contains("clear stakes, escalating conflict") == true)
        #expect(userContent?.contains("200,000-250,000 words") == true)
        #expect(userContent?.contains("polished, professional") == true)
    }
    
    @Test
    func body_handlesEmptyValues() throws {
        let story = Story(mainCharacter: "", setting: "")
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        
        #expect(messages?.count == 2)
        
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains("**Setting:**") == true)
        #expect(userContent?.contains("**Main Character:**") == true)
    }
    
    @Test
    func body_includesReasoning() throws {
        let story = Story(mainCharacter: "Test", setting: "Test")
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
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
        let endpoint = CreatePlotOutlineEndpoint(story: story)
        
        // This test verifies the response type is correctly defined
        let _: OpenRouterResponse.Type = CreatePlotOutlineEndpoint.Response.self
        
        // Test passes if compilation succeeds
        #expect(true)
    }
}
