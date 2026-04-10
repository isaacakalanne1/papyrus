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
        let upcomingHorizonSection = buildUpcomingHorizonSection()

        var contextLines = """
        [Context Provided]
        - Story Premise: \(plotPremise)
        - Narrative Perspective: \(story.perspective.promptDescription)
        - Current Chapter: Chapter \(currentChapterNumber) — \(currentSummary.summary)
        """

        if let horizonSection = upcomingHorizonSection {
            contextLines += "\n" + horizonSection
        }

        contextLines += "\n- Previous Written Chapters: \(previousChaptersContent)"

        let upcomingHorizonInstruction: String
        if upcomingHorizonSection != nil {
            upcomingHorizonInstruction = " DO NOT write the events of the Upcoming Horizon. The upcoming horizon is provided only so you can subtly foreshadow future events, build appropriate tension, and align character motivations. Keep the narrative strictly confined to resolving the beats of Chapter \(currentChapterNumber)."
        } else {
            upcomingHorizonInstruction = ""
        }

        return """
        \(contextLines)

        [Instructions]
        You are writing Chapter \(currentChapterNumber).\(upcomingHorizonInstruction)

        Write the full chapter text now, ensuring it's a standalone masterpiece that honors the story's vision and leaves readers eager for more.
        """
    }

    private func buildUpcomingHorizonSection() -> String? {
        let startIndex = currentChapterIndex + 1
        let endIndex = min(startIndex + 3, story.chapterSummaries.count)

        guard startIndex < story.chapterSummaries.count else {
            return nil
        }

        let upcomingChapters = story.chapterSummaries[startIndex ..< endIndex]

        let lines = upcomingChapters.map { chapterSummary in
            "    Chapter \(chapterSummary.chapterNumber): \(chapterSummary.summary)"
        }.joined(separator: "\n")

        return "- Upcoming Horizon (DO NOT write these events — for foreshadowing context only):\n\(lines)"
    }
}
