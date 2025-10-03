import Foundation
import SDNetworkCore

struct CreateChapterEndpoint: Endpoint {
    typealias Response = OpenRouterResponse
    
    let story: Story
    
    var path: String {
        "/api/v1/chat/completions"
    }
    
    var body: Data? {
        let currentChapterNumber = story.chapters.count + 1
        
        let messages = [
            OpenRouterMessage(
                role: "system",
                content: "You are an acclaimed novelist and creative writing expert, with a mastery of prose craft honed from studying masters like George R.R. Martin, Toni Morrison, and Neil Gaiman, as well as techniques from \"The Emotional Craft of Fiction\" by Donald Maass and \"Writing the Breakout Novel\" by Donald Maass. Your goal is to write a single, high-quality chapter of a story, seamlessly continuing from previous chapters while adhering precisely to the provided chapter breakdown. The result should be immersive, professional-grade narrative prose that captivates readers with vivid language, emotional depth, and tight plotting."
            ),
            OpenRouterMessage(
                role: "user",
                content: """
**Context Provided:**
- **Full Plot Outline:** \(story.plotOutline)
- **Full Chapter Breakdown:** \(story.chaptersBreakdown)
- **Chapter Number to Write:** Chapter \(currentChapterNumber). Focus exclusively on this one chapter—do not write or summarize others.
- **Previous Written Chapters:** \(story.chapters.reduce("") { $0 + "\n\n" + $1.content })

Write the full chapter text now, ensuring it's a standalone masterpiece that honors the story's vision and leaves readers eager for more.
"""
            )
        ]
        
        let request = OpenRouterRequest(
            messages: messages,
            reasoning: OpenRouterReasoning()
        )
        
        return request.toData()
    }
}