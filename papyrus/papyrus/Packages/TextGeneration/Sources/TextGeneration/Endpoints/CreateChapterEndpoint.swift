import Foundation
import SDNetworkCore

struct CreateChapterEndpoint: Endpoint {
    typealias Response = OpenRouterResponse

    let story: Story

    var path: String {
        "/api/v1/chat/completions"
    }

    var body: Data? {
        let messages = [
            OpenRouterMessage(
                role: "system",
                content: "You are an acclaimed novelist and creative writing expert, with a mastery of prose craft honed from studying masters like George R.R. Martin, Toni Morrison, and Neil Gaiman, as well as techniques from \"The Emotional Craft of Fiction\" by Donald Maass and \"Writing the Breakout Novel\" by Donald Maass. Your goal is to write a single, high-quality chapter of a story, seamlessly continuing from previous chapters while adhering precisely to the provided chapter breakdown. The result should be immersive, professional-grade narrative prose that captivates readers with vivid language, emotional depth, and tight plotting."
            ),
            OpenRouterMessage(
                role: "user",
                content: userMessageContent
            ),
        ]

        let request = OpenRouterRequest(
            messages: messages,
            reasoning: OpenRouterReasoning()
        )

        return request.toData()
    }

    // MARK: - Private

    private var currentChapterIndex: Int {
        story.chapters.count
    }

    private var currentChapterNumber: Int {
        currentChapterIndex + 1
    }

    private var useLegacyPrompt: Bool {
        story.chapterSummaries.isEmpty
    }

    private var plotPremise: String {
        story.plotSummary.isEmpty ? story.plotOutline : story.plotSummary
    }

    private var previousChaptersContent: String {
        story.chapters.reduce("") { $0 + "\n\n" + $1.content }
    }

    private var userMessageContent: String {
        if useLegacyPrompt {
            return legacyUserMessageContent
        }
        return progressiveDisclosureUserMessageContent
    }

    private var legacyUserMessageContent: String {
        """
        **Context Provided:**
        - **Full Plot Outline:** \(story.plotOutline)
        - **Full Chapter Breakdown:** \(story.chaptersBreakdown)
        - **Narrative Perspective:** \(story.perspective.promptDescription)
        - **Chapter Number to Write:** Chapter \(currentChapterNumber). Focus exclusively on this one chapter—do not write or summarize others.
        - **Previous Written Chapters:** \(previousChaptersContent)

        Write the full chapter text now, ensuring it's a standalone masterpiece that honors the story's vision and leaves readers eager for more.
        """
    }

    private var progressiveDisclosureUserMessageContent: String {
        let currentSummary = story.chapterSummaries[currentChapterIndex]

        return """
        [Context Provided]
        - Previous Written Chapters: \(previousChaptersContent)

        [Instructions]
        You are writing Chapter \(currentChapterNumber).
        - Narrative Perspective: \(story.perspective.promptDescription)
        - Chapter \(currentChapterNumber) Summary: \(currentSummary.summary)

        Write the full chapter text now, targeting approximately 2000 words. Ensure it's a standalone masterpiece that honors the story's vision and leaves readers eager for more. Do not include any footer, author's note, or closing commentary after the chapter text.
        """
    }
}
