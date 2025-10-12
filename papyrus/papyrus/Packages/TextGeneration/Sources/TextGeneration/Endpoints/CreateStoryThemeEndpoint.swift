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
                role: "system",
                content: "You are a creative story theme analyzer. Identify the core theme and genre of a story based on the main character and setting."
            ),
            OpenRouterMessage(
                role: "user",
                content: """
You are an expert in narrative themes and genres. Your task is to analyze the provided main character and setting to identify the most likely story theme the user wants to explore.

**Context Provided:**
- **Main Character:** \(story.mainCharacter)
- **Setting:** \(story.setting)

**Task:**
Based on these elements, provide a concise description of the story's theme and genre. Consider:
- The implicit narrative potential in the character/setting combination
- Common themes that naturally emerge from these elements
- The likely tone and emotional core of the story
- Genre conventions that might apply

Provide a 2-3 sentence theme description that captures the essence of what this story will likely explore.
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