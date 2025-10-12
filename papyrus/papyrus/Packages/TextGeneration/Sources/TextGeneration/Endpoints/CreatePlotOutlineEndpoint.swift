import Foundation
import SDNetworkCore

struct CreatePlotOutlineEndpoint: Endpoint {
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
You are an expert story plot writer, who writes plot outlines for full-length novels (around 250,000 words, 45-50 chapters). Below are the details for the story:

Main Character: \(story.mainCharacter)

Setting & details: \(story.setting)

Theme description: \(story.themeDescription)

Write the plot outline for the story based on the above details
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
