import Foundation
import SDNetworkCore

struct CreateSequelPlotOutlineEndpoint: Endpoint {
    typealias Response = OpenRouterResponse
    
    let story: Story
    let previousStory: Story
    
    var path: String {
        "/api/v1/chat/completions"
    }
    
    var body: Data? {
        let previousChaptersText = previousStory.chapters
            .enumerated()
            .map { index, chapter in
                "Chapter \(index + 1):\n\(chapter.content)"
            }
            .joined(separator: "\n\n")
        
        let messages = [
            OpenRouterMessage(
                role: "system",
                content: "You are a creative story planner specializing in creating sequels. Create a compelling sequel plot outline that builds upon the previous story while introducing fresh conflicts and character development."
            ),
            OpenRouterMessage(
                role: "user",
                content: """
You are an expert storyteller and narrative designer with deep knowledge of classic and modern storytelling techniques, including the hero's journey, three-act structure, and principles from Joseph Campbell, Robert McKee, and Syd Field. Your goal is to create a compelling, original plot outline for a story sequel based on the provided context, setting and main character.

**Previous Story Context:**
- **Setting:** \(previousStory.setting)
- **Main Character:** \(previousStory.mainCharacter)
- **Previous Plot Outline:** \(previousStory.plotOutline)
- **Previous Story Chapters:** \(previousChaptersText)

**New Sequel Context:**
- **Setting:** \(story.setting)
- **Main Character:** \(story.mainCharacter)

**Task:**
Develop a high-quality sequel plot outline that integrates the setting and main character seamlessly. The outline should be original, engaging, and emotionally resonant, with clear stakes, escalating conflict, and satisfying resolution. Aim for a story length equivalent to a novel (around 200,000-250,000 words if written out).

Generate the sequel plot outline now, ensuring it creates a worthy continuation of the story.
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