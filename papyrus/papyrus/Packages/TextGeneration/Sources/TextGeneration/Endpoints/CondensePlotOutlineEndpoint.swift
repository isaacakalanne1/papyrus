import Foundation
import SDNetworkCore

struct CondensePlotOutlineEndpoint: Endpoint {
    typealias Response = OpenRouterResponse

    let story: Story

    var path: String {
        "/api/v1/chat/completions"
    }

    var body: Data? {
        let messages = [
            OpenRouterMessage(
                role: "system",
                content: "You are a master story analyst. Distill story outlines into precise, compelling loglines. Output only the requested sentences with no preamble, labels, or markdown."
            ),
            OpenRouterMessage(
                role: "user",
                content: """
                Distill the following plot outline into exactly 3–5 sentences that capture: the genre, the protagonist and their core motivation, the central conflict, the stakes, and the thematic resolution.

                Output only the sentences — no preamble, no labels, no markdown.

                Plot outline:
                \(story.plotOutline)
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
