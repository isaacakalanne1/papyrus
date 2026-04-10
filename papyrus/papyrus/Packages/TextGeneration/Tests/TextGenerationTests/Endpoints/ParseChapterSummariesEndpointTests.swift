//
//  ParseChapterSummariesEndpointTests.swift
//  TextGeneration
//

import Foundation
import SDNetworkCore
import Testing
@testable import TextGeneration

class ParseChapterSummariesEndpointTests {
    // MARK: - Initialization Tests

    @Test
    func initialization() {
        let chaptersBreakdown = "Chapter 1: The hero departs. Chapter 2: The first trial."
        let story = Story(chaptersBreakdown: chaptersBreakdown)
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        #expect(endpoint.story.chaptersBreakdown == chaptersBreakdown)
    }

    // MARK: - Path Tests

    @Test
    func path() {
        let story = Story()
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        #expect(endpoint.path == "/api/v1/chat/completions")
    }

    // MARK: - Body Tests

    @Test
    func body_createsValidData() {
        let story = Story(chaptersBreakdown: "Chapter 1: Introduction to the world.")
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body

        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }

    @Test
    func body_containsCorrectJSON() throws {
        let chaptersBreakdown = "Chapter 1: The protagonist discovers a secret map."
        let story = Story(chaptersBreakdown: chaptersBreakdown)
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        #expect(json != nil)

        #expect(json?["model"] as? String == "x-ai/grok-4-fast")

        let messages = json?["messages"] as? [[String: Any]]
        #expect(messages?.count == 2)

        let systemMessage = messages?[0]
        #expect(systemMessage?["role"] as? String == "system")

        let userMessage = messages?[1]
        #expect(userMessage?["role"] as? String == "user")
    }

    @Test
    func body_systemMessage_instructsJSONOnlyOutput() throws {
        let story = Story(chaptersBreakdown: "Chapter 1: Adventure begins.")
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let systemMessage = messages?[0]
        let systemContent = systemMessage?["content"] as? String

        #expect(systemContent?.contains("valid JSON") == true)
        #expect(systemContent?.contains("no markdown") == true)
    }

    @Test
    func body_userMessage_includesChaptersBreakdown() throws {
        let chaptersBreakdown = "Chapter 1: A mysterious letter arrives.\nChapter 2: The journey to the north."
        let story = Story(chaptersBreakdown: chaptersBreakdown)
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String

        #expect(userContent?.contains(chaptersBreakdown) == true)
    }

    @Test
    func body_userMessage_specifiesJSONSchema() throws {
        let story = Story(chaptersBreakdown: "Chapter 1: The beginning.")
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String

        #expect(userContent?.contains("chapterNumber") == true)
        #expect(userContent?.contains("summary") == true)
    }

    @Test
    func body_userMessage_instructsJSONArrayOutput() throws {
        let story = Story(chaptersBreakdown: "Chapter 1: Setting the scene.")
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String

        #expect(userContent?.contains("[") == true)
        #expect(userContent?.contains("]") == true)
    }

    @Test
    func body_userMessage_forbidsMarkdownWrapper() throws {
        let story = Story(chaptersBreakdown: "Chapter 1: The call to adventure.")
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String

        #expect(userContent?.contains("no markdown") == true || userContent?.contains("code fences") == true)
    }

    @Test
    func body_handlesEmptyChaptersBreakdown() throws {
        let story = Story(chaptersBreakdown: "")
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]

        #expect(messages?.count == 2)
    }

    @Test
    func body_includesReasoning() throws {
        let story = Story(chaptersBreakdown: "Chapter 1: Test.")
        let endpoint = ParseChapterSummariesEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]

        let reasoning = json?["reasoning"] as? [String: Any]
        #expect(reasoning != nil)
        #expect(reasoning?["max_tokens"] as? Int == 5000)
    }

    // MARK: - Response Type Tests

    @Test
    func responseType() {
        let story = Story()
        _ = ParseChapterSummariesEndpoint(story: story)

        let _: OpenRouterResponse.Type = ParseChapterSummariesEndpoint.Response.self

        #expect(true)
    }

    // MARK: - Response Decoding Tests

    @Test
    func responseContent_decodesIntoChapterSummaries() throws {
        let jsonContent = """
        [
          {"chapterNumber": 1, "summary": "The hero departs on a quest."},
          {"chapterNumber": 2, "summary": "The first obstacle is overcome."},
          {"chapterNumber": 3, "summary": "An unexpected ally joins."}
        ]
        """
        let data = Data(jsonContent.utf8)
        let summaries = try JSONDecoder().decode([ChapterSummary].self, from: data)

        #expect(summaries.count == 3)
        #expect(summaries[0].chapterNumber == 1)
        #expect(summaries[0].summary == "The hero departs on a quest.")
        #expect(summaries[1].chapterNumber == 2)
        #expect(summaries[2].chapterNumber == 3)
    }
}
