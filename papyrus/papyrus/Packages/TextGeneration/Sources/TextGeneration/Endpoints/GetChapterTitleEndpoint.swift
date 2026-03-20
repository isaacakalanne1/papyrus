import Foundation
import SDNetworkCore

struct GetChapterTitleEndpoint: Endpoint {
    typealias Response = OpenRouterResponse
    
    let story: Story
    
    var path: String {
        "/api/v1/chat/completions"
    }
    
    private var storyContext: String {
        if !story.plotOutline.isEmpty {
            return """
Based on the following story details, respond with the story title:

**Plot Outline:** \(story.plotOutline)
"""
        } else {
            return """
Based on the following story details, respond with the story title:

**Main Character:** \(story.mainCharacter)
**Setting:** \(story.setting)
**Perspective:** \(story.perspective.promptDescription)
"""
        }
    }

    var body: Data? {
        let messages = [
            OpenRouterMessage(
                role: "system",
                content: "You are a creative story titling expert. Generate a compelling title for a story based on its details."
            ),
            OpenRouterMessage(
                role: "user",
                content: storyContext
            )
        ]
        
        let request = OpenRouterRequest(
            messages: messages
        )
        
        return request.toData()
    }
}