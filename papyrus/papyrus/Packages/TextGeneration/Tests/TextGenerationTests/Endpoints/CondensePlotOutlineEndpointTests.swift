//
//  CondensePlotOutlineEndpointTests.swift
//  TextGeneration
//

import Foundation
import SDNetworkCore
import Testing
@testable import TextGeneration

class CondensePlotOutlineEndpointTests {
    // MARK: - Initialization Tests

    @Test
    func initialization() {
        let plotOutline = "A hero journeys into the unknown to save the world."
        let story = Story(plotOutline: plotOutline)
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        #expect(endpoint.story.plotOutline == plotOutline)
    }

    // MARK: - Path Tests

    @Test
    func path() {
        let story = Story()
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        #expect(endpoint.path == "/api/v1/chat/completions")
    }

    // MARK: - Body Tests

    @Test
    func body_createsValidData() {
        let story = Story(plotOutline: "A sweeping epic about loss and redemption.")
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        let bodyData = endpoint.body

        #expect(bodyData != nil)
        #expect(bodyData!.count > 0)
    }

    @Test
    func body_containsCorrectJSON() throws {
        let plotOutline = "A warrior rises to defend a fallen kingdom."
        let story = Story(plotOutline: plotOutline)
        let endpoint = CondensePlotOutlineEndpoint(story: story)

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
    func body_systemMessage_instructsNoPreamble() throws {
        let story = Story(plotOutline: "An orphan discovers her magical heritage.")
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let systemMessage = messages?[0]
        let systemContent = systemMessage?["content"] as? String

        #expect(systemContent?.contains("no preamble") == true)
        #expect(systemContent?.contains("markdown") == true)
    }

    @Test
    func body_userMessage_includesPlotOutline() throws {
        let plotOutline = "A detective uncovers a conspiracy that reaches the highest offices of power."
        let story = Story(plotOutline: plotOutline)
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String

        #expect(userContent?.contains(plotOutline) == true)
    }

    @Test
    func body_userMessage_requestsThreeToFiveSentences() throws {
        let story = Story(plotOutline: "A quiet village is threatened by ancient evil.")
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String

        #expect(userContent?.contains("3") == true)
        #expect(userContent?.contains("5") == true)
    }

    @Test
    func body_userMessage_specifiesRequiredElements() throws {
        let story = Story(plotOutline: "An astronaut is stranded on Mars.")
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String

        #expect(userContent?.contains("genre") == true)
        #expect(userContent?.contains("protagonist") == true)
        #expect(userContent?.contains("conflict") == true)
        #expect(userContent?.contains("stakes") == true)
    }

    @Test
    func body_userMessage_instructsNoPreamble() throws {
        let story = Story(plotOutline: "A time traveller tries to fix a mistake.")
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]
        let userMessage = messages?[1]
        let userContent = userMessage?["content"] as? String

        #expect(userContent?.contains("no preamble") == true)
    }

    @Test
    func body_handlesEmptyPlotOutline() throws {
        let story = Story(plotOutline: "")
        let endpoint = CondensePlotOutlineEndpoint(story: story)

        let bodyData = endpoint.body
        #expect(bodyData != nil)

        let json = try JSONSerialization.jsonObject(with: bodyData!) as? [String: Any]
        let messages = json?["messages"] as? [[String: Any]]

        #expect(messages?.count == 2)
    }

    @Test
    func body_includesReasoning() throws {
        let story = Story(plotOutline: "A rebellion against a tyrannical empire.")
        let endpoint = CondensePlotOutlineEndpoint(story: story)

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
        _ = CondensePlotOutlineEndpoint(story: story)

        let _: OpenRouterResponse.Type = CondensePlotOutlineEndpoint.Response.self

        #expect(true)
    }
}
