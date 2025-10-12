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
                role: "user",
                content: """
You are an expert storywriter who writes the specified chapter for a story (the chapter is around 4000 words long) based on the below provided story details:

Main Character: \(story.mainCharacter)

Setting & details: \(story.setting)

Theme description: \(story.themeDescription)

Plot outline: \(story.plotOutline)

\(story.chaptersBreakdown.isEmpty ? "" : "Chapter breakdown: \(story.chaptersBreakdown)")

Chapters so far: \(story.chapters.reduce("") { $0 + "\n\n" + $1.content })

Chapters so far: \(story.chapters.reduce("") { $0 + "\n\n" + $1.content })

Chapters so far: \(story.chapters.reduce("") { $0 + "\n\n" + $1.content })

Write chapter \(currentChapterNumber) based on the above story details
"""
            )
        ]
        
        let request = OpenRouterRequest(
//            model: "deepseek/deepseek-v3.2-exp",
            messages: messages,
            reasoning: OpenRouterReasoning()
        )
        
        return request.toData()
    }
}
