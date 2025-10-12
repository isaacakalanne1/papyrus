import Foundation
import SDNetworkCore

struct GetChapterTitleEndpoint: Endpoint {
    typealias Response = OpenRouterResponse
    
    let story: Story
    
    var path: String {
        "/api/v1/chat/completions"
    }
    
    var body: Data? {
        let messages = [
            OpenRouterMessage(
                role: "system",
                content: ""
            ),
            OpenRouterMessage(
                role: "user",
                content: """
Based on the following story details, respond with the story title:

**Plot Outline:** \(story.plotOutline)

Reply with only the story title.
"""
            )
        ]
        
        let request = OpenRouterRequest(
            messages: messages
        )
        
        return request.toData()
    }
}
