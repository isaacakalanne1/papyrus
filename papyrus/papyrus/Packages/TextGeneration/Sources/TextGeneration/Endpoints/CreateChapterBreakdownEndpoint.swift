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
                role: "system",
                content: "You are a story structure expert. Create a detailed chapter breakdown for a story."
            ),
            OpenRouterMessage(
                role: "user",
                content: """
You are an expert narrative architect and editor with extensive experience in breaking down stories into chapters, drawing from techniques in books like "Save the Cat" by Blake Snyder, "Story Genius" by Lisa Cron, and "The Anatomy of Story" by John Truby. Your goal is to create a detailed, high-quality chapter breakdown for a story based on the provided plot outline. This breakdown will serve as a blueprint for writing, ensuring smooth pacing, escalating tension, and deep character immersion.

**Context Provided:**
- **Plot Outline:** \(story.plotOutline)

**Task:**
Expand the plot outline into a chapter-by-chapter breakdown for a complete story. Aim for 40-55 chapters to fit a novel-length narrative (200,000-250,000 words), distributing chapters logically across the three acts (e.g., 10-15 in Act 1, 23-25 in Act 2, 7-10 in Act 3). Each chapter must stand alone in the breakdown with its own dedicated outline—no grouping chapters into ranges (e.g., avoid "Chapters 5-7"; treat each as "Chapter 5," "Chapter 6," etc.). Ensure the breakdown faithfully adapts the plot outline while adding granular details like key scenes, character arcs, dialogue hooks, and sensory elements to make it vivid and actionable.

Generate the chapter breakdown now, ensuring it's polished, immersive, and optimized for writing a gripping story.
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