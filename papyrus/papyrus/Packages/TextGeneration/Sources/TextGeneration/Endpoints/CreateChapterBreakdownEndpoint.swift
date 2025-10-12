import Foundation
import SDNetworkCore

struct CreateChapterBreakdownEndpoint: Endpoint {
    typealias Response = OpenRouterResponse
    
    let story: Story
    
    var path: String {
        "/api/v1/chat/completions"
    }
    
    var body: Data? {
        let messages = [
            OpenRouterMessage(
                role: "user",
                content: """
You are an expert chapter breakdown writer, who breaks a story down into chapters based on the provided main character, theme, and plot outline

Main Character: \(story.mainCharacter)

Setting & details: \(story.setting)

Theme description: \(story.themeDescription)

Plot outline: \(story.plotOutline)

Write the chapter breakdown for the story, based on the above details
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
