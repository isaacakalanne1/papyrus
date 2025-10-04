//
//  CreateChapterBreakdownEndpointTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import SDNetworkCore
@testable import TextGeneration

class CreateChapterBreakdownEndpointTests {
    
    // MARK: - Initialization Tests
    
    @Test
    func initialization() {
        let plotOutline = "A detective investigates mysterious murders in a haunted mansion"
        let story = Story(plotOutline: plotOutline)
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        #expect(endpoint.story.plotOutline == plotOutline)
    }
    
    // MARK: - Path Tests
    
    @Test
    func path() {
        let story = Story()
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        #expect(endpoint.path == "/api/v1/chat/completions")
    }
    
    // MARK: - Body Tests
    
    @Test
    func body_createsValidData() {
        let story = Story(plotOutline: "Space exploration adventure with alien encounters")
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        let bodyData = endpoint.body
        
        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }
    
    @Test
    func body_containsCorrectJSON() throws {
        let plotOutline = "Epic fantasy quest to retrieve a magical artifact"
        let story = Story(plotOutline: plotOutline)
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
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
        #expect(systemContent?.contains("story structure expert") == true)
        #expect(systemContent?.contains("detailed chapter breakdown") == true)
        
        // Verify user message
        let userMessage = messages?[1]
        #expect(userMessage?["role"] as? String == "user")
        let userContent = userMessage?["content"] as? String
        #expect(userContent?.contains(plotOutline) == true)
    }
    
    @Test
    func body_includesNarrativeExpertise() throws {
        let story = Story(plotOutline: "Romance in a small coastal town")
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify narrative expertise references
        #expect(userContent?.contains("Blake Snyder") == true)
        #expect(userContent?.contains("Lisa Cron") == true)
        #expect(userContent?.contains("John Truby") == true)
        #expect(userContent?.contains("Save the Cat") == true)
        #expect(userContent?.contains("Story Genius") == true)
        #expect(userContent?.contains("The Anatomy of Story") == true)
    }
    
    @Test
    func body_includesPlotOutline() throws {
        let plotOutline = "Post-apocalyptic survival story with mutant creatures and hidden underground cities"
        let story = Story(plotOutline: plotOutline)
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        #expect(userContent?.contains("**Plot Outline:** \(plotOutline)") == true)
    }
    
    @Test
    func body_includesChapterRequirements() throws {
        let story = Story(plotOutline: "Mystery thriller in corporate boardroom")
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify chapter requirements
        #expect(userContent?.contains("40-55 chapters") == true)
        #expect(userContent?.contains("200,000-250,000 words") == true)
        #expect(userContent?.contains("three acts") == true)
        #expect(userContent?.contains("10-15 in Act 1") == true)
        #expect(userContent?.contains("23-25 in Act 2") == true)
        #expect(userContent?.contains("7-10 in Act 3") == true)
    }
    
    @Test
    func body_includesChapterStandAloneRequirement() throws {
        let story = Story(plotOutline: "Historical drama during World War II")
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify chapter standalone requirements
        #expect(userContent?.contains("Each chapter must stand alone") == true)
        #expect(userContent?.contains("no grouping chapters into ranges") == true)
        #expect(userContent?.contains("avoid \"Chapters 5-7\"") == true)
        #expect(userContent?.contains("treat each as \"Chapter 5,\" \"Chapter 6,\"") == true)
    }
    
    @Test
    func body_includesDetailRequirements() throws {
        let story = Story(plotOutline: "Science fiction time travel paradox")
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify detail requirements
        #expect(userContent?.contains("key scenes, character arcs") == true)
        #expect(userContent?.contains("dialogue hooks") == true)
        #expect(userContent?.contains("sensory elements") == true)
        #expect(userContent?.contains("vivid and actionable") == true)
    }
    
    @Test
    func body_includesQualityRequirements() throws {
        let story = Story(plotOutline: "Urban fantasy with magical creatures")
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
        let bodyData = endpoint.body
        #expect(bodyData != nil)
        
        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String
        
        // Verify quality requirements
        #expect(userContent?.contains("smooth pacing, escalating tension") == true)
        #expect(userContent?.contains("deep character immersion") == true)
        #expect(userContent?.contains("polished, immersive") == true)
        #expect(userContent?.contains("optimized for writing a gripping story") == true)
    }
    
    @Test
    func body_handlesEmptyPlotOutline() throws {
        let story = Story(plotOutline: "")
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
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
    func body_includesReasoning() throws {
        let story = Story(plotOutline: "Test plot")
        let endpoint = CreateChapterBreakdownEndpoint(story: story)
        
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
        let _ = CreateChapterBreakdownEndpoint(story: story)
        
        // This test verifies the response type is correctly defined
        let _: OpenRouterResponse.Type = CreateChapterBreakdownEndpoint.Response.self
        
        // Test passes if compilation succeeds
        #expect(true)
    }
}
