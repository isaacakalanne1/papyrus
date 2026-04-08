import Foundation
import SDNetworkCore

struct GenerateParagraphEndpoint: Endpoint {
    typealias Response = OpenRouterResponse

    let story: Story
    let sentenceCount: Int

    var path: String {
        "/api/v1/chat/completions"
    }

    private var sentenceLabel: String {
        sentenceCount == 1 ? "1 sentence" : "\(sentenceCount) sentences"
    }

    var body: Data? {
        let priorChapters = story.chapters.dropLast()
        let pendingChapter = story.chapters.last

        var userContent = """
        You are writing an interactive fiction story.

        **Character:** \(story.mainCharacter)
        **Setting:** \(story.setting)
        **Narrative Perspective:** \(story.perspective.promptDescription)
        """

        if !priorChapters.isEmpty {
            let priorText = priorChapters.map { $0.content }.joined(separator: "\n\n")
            userContent += "\n\n**Story so far:**\n\(priorText)"
        }

        if let action = pendingChapter?.action {
            userContent += "\n\n**Player action:** \(action.promptDescription)"
        }

        userContent += "\n\nContinue the story naturally with exactly \(sentenceLabel). Do not include chapter headings."

        let messages = [
            OpenRouterMessage(
                role: "system",
                content: "You are an acclaimed interactive fiction author with a gift for immersive, concise prose. Your job is to continue a story in response to the player's action, writing exactly \(sentenceLabel) of narrative. Do not include chapter headings, labels, or meta-commentary. Write only the paragraph."
            ),
            OpenRouterMessage(
                role: "user",
                content: userContent
            ),
        ]

        let request = OpenRouterRequest(model: "deepseek/deepseek-v3.2", messages: messages)
        return request.toData()
    }
}
