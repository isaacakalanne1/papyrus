//
//  BaseTextGenerationEndpointTests.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
@testable import TextGeneration

class BaseTextGenerationEndpointTests {
    
    // MARK: - OpenRouterMessage Tests
    
    @Test
    func openRouterMessage_encoding() throws {
        let message = OpenRouterMessage(role: "system", content: "Test content")
        
        let data = try JSONEncoder().encode(message)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        #expect(json?["role"] as? String == "system")
        #expect(json?["content"] as? String == "Test content")
    }
    
    // MARK: - OpenRouterReasoning Tests
    
    @Test
    func openRouterReasoning_defaultInitialization() {
        let reasoning = OpenRouterReasoning()
        
        #expect(reasoning.max_tokens == 10_000)
        #expect(reasoning.temperature == nil)
    }
    
    @Test
    func openRouterReasoning_customInitialization() {
        let reasoning = OpenRouterReasoning(max_tokens: 3000, temperature: 0.8)
        
        #expect(reasoning.max_tokens == 3000)
        #expect(reasoning.temperature == 0.8)
    }
    
    @Test
    func openRouterReasoning_encoding() throws {
        let reasoning = OpenRouterReasoning(max_tokens: 2000, temperature: 0.5)
        
        let data = try JSONEncoder().encode(reasoning)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        #expect(json?["max_tokens"] as? Int == 2000)
        #expect(json?["temperature"] as? Float == 0.5)
    }
    
    // MARK: - OpenRouterRequest Tests
    
    @Test
    func openRouterRequest_defaultInitialization() {
        let messages = [OpenRouterMessage(role: "user", content: "Test")]
        let request = OpenRouterRequest(messages: messages)
        
        #expect(request.model == "deepseek/deepseek-chat-v3.1")
        #expect(request.messages.count == 1)
        #expect(request.messages[0].role == "user")
        #expect(request.messages[0].content == "Test")
        #expect(request.temperature == nil)
        #expect(request.max_tokens == 10_000)
    }
    
    @Test
    func openRouterRequest_customInitialization() {
        let messages = [
            OpenRouterMessage(role: "system", content: "System message"),
            OpenRouterMessage(role: "user", content: "User message")
        ]
        let reasoning = OpenRouterReasoning(max_tokens: 1000, temperature: 0.9)
        let request = OpenRouterRequest(
            model: "custom-model",
            messages: messages,
            reasoning: reasoning
        )
        
        #expect(request.model == "custom-model")
        #expect(request.messages.count == 2)
        #expect(request.messages[0].role == "system")
        #expect(request.messages[1].role == "user")
        #expect(request.temperature == 0.9)
        #expect(request.max_tokens == 1000)
    }
    
    @Test
    func openRouterRequest_encoding() throws {
        let messages = [OpenRouterMessage(role: "user", content: "Test content")]
        let reasoning = OpenRouterReasoning(max_tokens: 1500, temperature: 0.7)
        let request = OpenRouterRequest(
            model: "test-model",
            messages: messages,
            reasoning: reasoning
        )
        
        let data = try JSONEncoder().encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        #expect(json?["model"] as? String == "test-model")
        
        let jsonMessages = json?["messages"] as? [[String: Any]]
        #expect(jsonMessages?.count == 1)
        #expect(jsonMessages?[0]["role"] as? String == "user")
        #expect(jsonMessages?[0]["content"] as? String == "Test content")
        
        #expect(json?["temperature"] as? Float == 0.7)
        #expect(json?["max_tokens"] as? Int == 1500)
    }
    
    @Test
    func openRouterRequest_encodingWithoutTemperature() throws {
        let messages = [OpenRouterMessage(role: "user", content: "Test")]
        let request = OpenRouterRequest(messages: messages)
        
        let data = try JSONEncoder().encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        
        #expect(json?["model"] as? String == "deepseek/deepseek-chat-v3.1")
        #expect(json?["temperature"] == nil)
        #expect(json?["max_tokens"] as? Int == 10_000)
    }
    
    // MARK: - OpenRouterRequest.toData() Tests
    
    @Test
    func openRouterRequest_toData_success() {
        let messages = [OpenRouterMessage(role: "user", content: "Test")]
        let request = OpenRouterRequest(messages: messages)
        
        let data = request.toData()
        
        #expect(data != nil)
        #expect(data!.count > 0)
    }
    
    @Test
    func openRouterRequest_toData_producesValidJSON() throws {
        let messages = [OpenRouterMessage(role: "user", content: "Test")]
        let request = OpenRouterRequest(messages: messages)
        
        let data = request.toData()
        #expect(data != nil)
        
        // Verify it's valid JSON by parsing it
        let json = try JSONSerialization.jsonObject(with: data!)
        #expect(json is [String: Any])
    }
}