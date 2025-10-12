import Foundation
import SDNetworkCore

struct CreateStoryThemeEndpoint: Endpoint {
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
You are an expert story theme creator, who specializes in detailing the type of story the user likely wants

Below is the provided story details by the user:
Main Character: \(story.mainCharacter)
Setting & details: \(story.setting)

Write out a detailed description of the story theme, the type of story the user likely wants
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
