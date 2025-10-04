//
//  GetChapterTitleEndpointTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import SDNetworkCore
@testable import TextGeneration

class GetChapterTitleEndpointTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func initialization() {
        let story = Story(plotOutline: "Test plot outline")
        let endpoint = GetChapterTitleEndpoint(story: story)
        
        #expect(endpoint.story.plotOutline == "Test plot outline")
    }
    
    // MARK: - Path Tests
    
    @Test
    func path() {
        let story = Story()
        let endpoint = GetChapterTitleEndpoint(story: story)
        
        #expect(endpoint.path == "/api/v1/chat/completions")
    }
    
    // MARK: - Body Tests
    
    @Test
    func body_createsValidData() {
        let story = Story(plotOutline: "A hero's journey through magical lands")
        let endpoint = GetChapterTitleEndpoint(story: story)
        
        let bodyData = endpoint.body
        
        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }
    
    @Test
    func body_containsCorrectJSON() throws {
        let story = Story(plotOutline: "Epic fantasy adventure")
        let endpoint = GetChapterTitleEndpoint(story: story)
        
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
        #expect(systemContent?.contains("creative story titling expert") == true)
        
        // Verify user message
        let userMessage = messages?[1]
        #expect(userMessage?["role"] as? String == "user")
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains("Epic fantasy adventure") == true)
        #expect(userContent?.contains("**Plot Outline:**") == true)
    }
    
    @Test
    func body_includesPlotOutlineInUserMessage() throws {
        let plotOutline = "A mysterious detective solves supernatural crimes in Victorian London"
        let story = Story(plotOutline: plotOutline)
        let endpoint = GetChapterTitleEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        #expect(userContent?.contains(plotOutline) == true)
    }
    
    @Test
    func body_handlesEmptyPlotOutline() throws {
        let story = Story(plotOutline: "")
        let endpoint = GetChapterTitleEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        
        #expect(messages?.count == 2)
        
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains("**Plot Outline:**") == true)
    }
    
    @Test
    func body_doesNotIncludeReasoning() throws {
        let story = Story(plotOutline: "Test plot")
        let endpoint = GetChapterTitleEndpoint(story: story)
        
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
        let endpoint = GetChapterTitleEndpoint(story: story)
        
        // This test verifies the response type is correctly defined
        let _: OpenRouterResponse.Type = GetChapterTitleEndpoint.Response.self
        
        // Test passes if compilation succeeds
        #expect(true)
    }
}
