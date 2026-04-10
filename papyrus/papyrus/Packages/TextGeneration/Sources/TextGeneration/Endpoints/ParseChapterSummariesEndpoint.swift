import Foundation
import SDNetworkCore

struct ParseChapterSummariesEndpoint: Endpoint {
    typealias Response = OpenRouterResponse

    let story: Story

    var path: String {
        "/api/v1/chat/completions"
    }

    var body: Data? {
        let messages = [
            OpenRouterMessage(
                role: "system",
                content: "You are a precise data extraction assistant. Output only valid JSON with no markdown formatting, code blocks, or additional text."
            ),
            OpenRouterMessage(
                role: "user",
                content: """
                Parse the following chapter breakdown into a JSON array. Each element must have exactly two fields:
                - "chapterNumber": an integer representing the chapter number
                - "summary": a string containing a concise summary of that chapter

                Output only valid JSON — no markdown, no code fences, no explanation. The output must start with [ and end with ].

                Chapter breakdown:
                \(story.chaptersBreakdown)
                """
            ),
        ]

        let request = OpenRouterRequest(
            messages: messages,
            reasoning: OpenRouterReasoning()
        )

        return request.toData()
    }
}
