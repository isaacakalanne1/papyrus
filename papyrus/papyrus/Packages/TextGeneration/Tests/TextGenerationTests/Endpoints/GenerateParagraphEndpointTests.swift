//
//  GenerateParagraphEndpointTests.swift
//  TextGeneration
//

import Foundation
import SDNetworkCore
import Testing
@testable import TextGeneration

class GenerateParagraphEndpointTests {
    // MARK: - Initialization Tests

    @Test
    func initialization_storesStoryAndSentenceCount() {
        let story = Story(mainCharacter: "Hero", setting: "Fantasy World")
        let endpoint = GenerateParagraphEndpoint(story: story, sentenceCount: 5)

        #expect(endpoint.story.mainCharacter == "Hero")
        #expect(endpoint.story.setting == "Fantasy World")
        #expect(endpoint.sentenceCount == 5)
    }

    // MARK: - Path Tests

    @Test
    func path_isOpenRouterCompletions() {
        let endpoint = GenerateParagraphEndpoint(story: Story(), sentenceCount: 3)

        #expect(endpoint.path == "/api/v1/chat/completions")
    }

    // MARK: - Body Tests

    @Test
    func body_createsValidData() {
        let endpoint = GenerateParagraphEndpoint(story: Story(), sentenceCount: 3)

        let bodyData = endpoint.body

        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }

    @Test
    func body_containsCorrectModel() throws {
        let endpoint = GenerateParagraphEndpoint(story: Story(), sentenceCount: 3)

        let json = try JSONSerialization.jsonObject(with: endpoint.body!) as? [String: Any]

        #expect(json?["model"] as? String == "deepseek/deepseek-v3.2")
    }

    @Test
    func body_containsTwoMessages() throws {
        let endpoint = GenerateParagraphEndpoint(story: Story(), sentenceCount: 3)

        let json = try JSONSerialization.jsonObject(with: endpoint.body!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]

        #expect(messages?.count == 2)
        #expect(messages?[0]["role"] as? String == "system")
        #expect(messages?[1]["role"] as? String == "user")
    }

    // MARK: - Sentence Count in Prompts

    @Test(arguments: [1, 3, 5, 10])
    func body_userMessage_containsSentenceCount(count: Int) throws {
        let story = Story(mainCharacter: "Alice", setting: "Wonderland")
        let endpoint = GenerateParagraphEndpoint(story: story, sentenceCount: count)

        let json = try JSONSerialization.jsonObject(with: endpoint.body!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userContent = messages?[1]["content"] as? String

        let expectedLabel = count == 1 ? "1 sentence" : "\(count) sentences"
        #expect(userContent?.contains(expectedLabel) == true)
    }

    @Test(arguments: [1, 3, 5, 10])
    func body_systemMessage_containsSentenceCount(count: Int) throws {
        let story = Story(mainCharacter: "Alice", setting: "Wonderland")
        let endpoint = GenerateParagraphEndpoint(story: story, sentenceCount: count)

        let json = try JSONSerialization.jsonObject(with: endpoint.body!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let systemContent = messages?[0]["content"] as? String

        let expectedLabel = count == 1 ? "1 sentence" : "\(count) sentences"
        #expect(systemContent?.contains(expectedLabel) == true)
    }

    @Test
    func body_singularSentence_usesSingularLabel() throws {
        let endpoint = GenerateParagraphEndpoint(story: Story(), sentenceCount: 1)

        let json = try JSONSerialization.jsonObject(with: endpoint.body!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userContent = messages?[1]["content"] as? String
        let systemContent = messages?[0]["content"] as? String

        #expect(userContent?.contains("1 sentence") == true)
        #expect(systemContent?.contains("1 sentence") == true)
        #expect(userContent?.contains("1 sentences") == false)
        #expect(systemContent?.contains("1 sentences") == false)
    }

    @Test
    func body_pluralSentences_usesPluralLabel() throws {
        let endpoint = GenerateParagraphEndpoint(story: Story(), sentenceCount: 4)

        let json = try JSONSerialization.jsonObject(with: endpoint.body!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userContent = messages?[1]["content"] as? String
        let systemContent = messages?[0]["content"] as? String

        #expect(userContent?.contains("4 sentences") == true)
        #expect(systemContent?.contains("4 sentences") == true)
    }

    // MARK: - Story Content in Prompts

    @Test
    func body_includesCharacterAndSetting() throws {
        let story = Story(mainCharacter: "Sherlock Holmes", setting: "Victorian London")
        let endpoint = GenerateParagraphEndpoint(story: story, sentenceCount: 3)

        let json = try JSONSerialization.jsonObject(with: endpoint.body!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userContent = messages?[1]["content"] as? String

        #expect(userContent?.contains("Sherlock Holmes") == true)
        #expect(userContent?.contains("Victorian London") == true)
    }
}
