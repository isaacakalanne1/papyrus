import Foundation
import SDNetworkCore

struct GetStoryDetailsEndpoint: Endpoint {
    typealias Response = OpenRouterResponse
    
    let story: Story
    
    var path: String {
        "/api/v1/chat/completions"
    }
    
    var body: Data? {
        let messages = [
            OpenRouterMessage(
                role: "system",
                content: "You are a story analysis expert. Count the total number of chapters in a plot outline and return only the integer number."
            ),
            OpenRouterMessage(
                role: "user",
                content: """
Analyze the following plot outline and return ONLY the total number of chapters as an integer (e.g., just "12" or "15"):

Plot outline:
\(story.plotOutline)
"""
            )
        ]
        
        let request = OpenRouterRequest(
            messages: messages
        )
        
        return request.toData()
    }
}
