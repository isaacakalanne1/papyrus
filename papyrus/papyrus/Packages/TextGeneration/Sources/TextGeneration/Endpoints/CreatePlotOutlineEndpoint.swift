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
                role: "system",
                content: "You are a creative story planner. Create a compelling plot outline for a story."
            ),
            OpenRouterMessage(
                role: "user",
                content: """
You are an expert storyteller and narrative designer with deep knowledge of classic and modern storytelling techniques, including the hero's journey, three-act structure, and principles from Joseph Campbell, Robert McKee, and Syd Field. Your goal is to create a compelling, original plot outline for a story based on the provided setting and main character.

**Context Provided:**
- **Setting:** \(story.setting)
- **Main Character:** \(story.mainCharacter)

**Task:**
Develop a high-quality plot outline that integrates the setting and main character seamlessly. The outline should be original, engaging, and emotionally resonant, with clear stakes, escalating conflict, and satisfying resolution. Aim for a story length equivalent to a novel (around 200,000-250,000 words if written out).

Generate the plot outline now, ensuring it's polished, professional, and ready to inspire a full story.
"""
            )
        ]
        
        let request = OpenRouterRequest(
            model: "x-ai/grok-4-fast:free",
            messages: messages
        )
        
        return request.toData()
    }
}