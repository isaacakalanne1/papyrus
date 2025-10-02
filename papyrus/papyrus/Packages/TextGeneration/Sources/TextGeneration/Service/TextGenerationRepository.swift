//
//  TextGenerationRepository.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import Foundation
import Settings

protocol TextGenerationRepositoryProtocol {
    func createPlotOutline(story originalStory: Story) async throws -> Story
    func createSequelPlotOutline(story originalStory: Story, previousStory: Story) async throws -> Story
    func createChapterBreakdown(story originalStory: Story) async throws -> Story
    func getStoryDetails(story originalStory: Story) async throws -> Story
    func getChapterTitle(story originalStory: Story) async throws -> Story
    func createChapter(story originalStory: Story, writingStyle: WritingStyle) async throws -> Story
}

public class TextGenerationRepository: TextGenerationRepositoryProtocol {
    private let apiURL = "https://openrouter.ai/api/v1/chat/completions"
    let apiKey = "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"
    
    public init() {

    }
    
    public func createPlotOutline(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a creative story planner. Create a compelling plot outline for a story."
                ],
                [
                    "role": "user",
                    "content": """
You are an expert storyteller and narrative designer with deep knowledge of classic and modern storytelling techniques, including the hero's journey, three-act structure, and principles from Joseph Campbell, Robert McKee, and Syd Field. Your goal is to create a compelling, original plot outline for a story based on the provided setting and main character.

**Context Provided:**
- **Setting:** \(story.setting)
- **Main Character:** \(story.mainCharacter)

**Task:**
Develop a high-quality plot outline that integrates the setting and main character seamlessly. The outline should be original, engaging, and emotionally resonant, with clear stakes, escalating conflict, and satisfying resolution. Aim for a story length equivalent to a novella or feature film (around 20,000-50,000 words if written out).

**Structure the Outline Using the Three-Act Structure:**
1. **Act 1: Setup (Introduction and Inciting Incident)**
   - Introduce the main character in their ordinary world within the setting.
   - Establish key relationships, motivations, flaws, and backstory.
   - Present the inciting incident that disrupts the status quo and propels the character into the main conflict.
   - End with the first turning point: the character commits to the journey.

2. **Act 2: Confrontation (Rising Action and Midpoint)**
   - Detail the main conflicts, both external (e.g., antagonists, environmental challenges in the setting) and internal (e.g., character's doubts or growth).
   - Include 3-5 key plot points or scenes that build tension, introduce subplots, and show character development.
   - Highlight the midpoint: a major reversal or revelation that raises the stakes.
   - Incorporate themes relevant to the setting and character (e.g., redemption, survival, identity).

3. **Act 3: Resolution (Climax and Denouement)**
   - Build to the climax: the final confrontation where the character faces their greatest challenge.
   - Resolve the main conflict, showing how the character has changed.
   - Provide a denouement that ties up loose ends, hints at the future, and delivers emotional payoff.

**Additional Guidelines for Quality:**
- Ensure the plot is logical and consistent with the setting's rules (e.g., technology, magic, societal norms).
- Create believable supporting characters, antagonists, and world-building elements that enhance the story without overwhelming it.
- Balance pacing: start slow to build investment, accelerate in Act 2, and peak in Act 3.
- Infuse variety, nuance, and moral complexity—avoid clichés unless subverted creatively.
- Make the outline vivid and specific, with sensory details, dialogue snippets, and emotional beats where helpful.
- Keep the total outline concise yet detailed (800-1500 words), using bullet points or numbered scenes for clarity.
- Genre: [Optional: Specify if needed, e.g., sci-fi thriller; otherwise, infer from context and lean toward the most fitting genre.]

Generate the plot outline now, ensuring it's polished, professional, and ready to inspire a full story.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TextGenerationError.invalidResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw TextGenerationError.parsingError
        }
        
        story.plotOutline = content
        
        return story
    }
    
    public func createSequelPlotOutline(story originalStory: Story, previousStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Get the previous story's chapters for context
        let previousChaptersText = previousStory.chapters.enumerated().map { index, chapter in 
            "Chapter \(index + 1):\n\(chapter.content)"
        }.joined(separator: "\n\n")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a creative story planner specializing in creating sequels. Create a compelling sequel plot outline that builds upon the previous story while introducing fresh conflicts and character development."
                ],
                [
                    "role": "user",
                    "content": """
You are an expert storyteller tasked with creating a sequel plot outline. You have access to the previous story and need to create a new, compelling narrative that continues the journey while standing on its own.

**Previous Story Context:**
- **Setting:** \(previousStory.setting)
- **Main Character:** \(previousStory.mainCharacter)
- **Previous Plot Outline:** \(previousStory.plotOutline)
- **Previous Story Summary:** Based on the chapters, the previous story concluded with the main character's journey. Here are the key story beats from the previous narrative:
\(previousChaptersText)

**New Sequel Context:**
- **Setting:** \(story.setting)
- **Main Character:** \(story.mainCharacter)

**Task:**
Create a sequel plot outline that:
1. **Honors the Previous Story:** Reference key events, character growth, and relationships from the first story
2. **Introduces New Stakes:** Present fresh challenges that are natural consequences or evolutions of the previous story's resolution
3. **Deepens Character Development:** Show how the main character has changed and what new growth is needed
4. **Expands the World:** Build upon the established setting with new locations, characters, or revelations

**Structure the Sequel Using the Three-Act Structure:**

**Act 1: New Normal and Inciting Incident**
- Show the main character in their new status quo after the events of the previous story
- Introduce how the world/character has changed since the last story
- Present a new inciting incident that creates fresh conflict while connecting to previous events
- End with the character accepting this new challenge

**Act 2: Escalating Complications and Midpoint**
- Develop new conflicts that test the character in different ways than the previous story
- Include callbacks and consequences from the previous story that create complications
- Show the character applying lessons learned while facing unprecedented challenges
- Feature a major midpoint revelation that recontextualizes both stories

**Act 3: Climax and Resolution**
- Build to a climax that requires growth beyond what was achieved in the first story
- Resolve conflicts in a way that provides satisfying closure while leaving room for further growth
- Show the character's evolution from both stories and hint at their future

**Guidelines for Quality Sequel Writing:**
- Avoid simply repeating the previous story's structure or conflicts
- Create new supporting characters while potentially bringing back beloved ones
- Raise the stakes emotionally and plot-wise without making them absurdly high
- Ensure the sequel can be enjoyed by newcomers while rewarding returning readers
- Balance nostalgia with innovation
- Keep the outline detailed (800-1500 words) with specific plot points and character beats

Generate the sequel plot outline now, ensuring it creates a worthy continuation of the story.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TextGenerationError.invalidResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw TextGenerationError.parsingError
        }
        
        story.plotOutline = content
        
        return story
    }
    
    public func createChapterBreakdown(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a story structure expert. Create a detailed chapter breakdown for a story."
                ],
                [
                    "role": "user",
                    "content": """
You are an expert narrative architect and editor with extensive experience in breaking down stories into chapters, drawing from techniques in books like "Save the Cat" by Blake Snyder, "Story Genius" by Lisa Cron, and "The Anatomy of Story" by John Truby. Your goal is to create a detailed, high-quality chapter breakdown for a story based on the provided plot outline. This breakdown will serve as a blueprint for writing, ensuring smooth pacing, escalating tension, and deep character immersion.

**Context Provided:**
- **Plot Outline:** \(story.plotOutline)

**Task:**
Expand the plot outline into a chapter-by-chapter breakdown for a complete story. Aim for 10-15 chapters to fit a novella or novel-length narrative (20,000-80,000 words), distributing chapters logically across the three acts (e.g., 3-4 in Act 1, 5-7 in Act 2, 2-4 in Act 3). Each chapter must stand alone in the breakdown with its own dedicated outline—no grouping chapters into ranges (e.g., avoid "Chapters 5-7"; treat each as "Chapter 5," "Chapter 6," etc.). Ensure the breakdown faithfully adapts the plot outline while adding granular details like key scenes, character arcs, dialogue hooks, and sensory elements to make it vivid and actionable.

**Structure the Chapter Breakdown:**
- **Overall Story Arc:** Briefly restate how chapters map to the three-act structure (e.g., Chapters 1-15: Act 1; Chapters 16-35: Act 2; Chapters 36-50: Act 3). Include estimated word count per chapter (e.g., 2,000-5,000 words) to guide pacing.
- **Chapter-by-Chapter Outlines:** For *each individual chapter*, provide:
  1. **Chapter Title:** A evocative, thematic title that hints at the content without spoiling.
  2. **Act and Position:** Specify the act and its role in the overall plot (e.g., "Act 1: Builds the ordinary world and inciting incident").
  3. **Summary (200-300 words):** A concise overview of the chapter's events, linking directly to the plot outline. Include:
     - Key scenes or beats (3-6 major moments).
     - Main character's actions, internal thoughts, and emotional progression.
     - Interactions with supporting characters, antagonists, or setting elements.
     - Rising tension, conflicts (external/internal), and subplots advanced.
     - Vivid details: Sensory descriptions, pivotal dialogue snippets, and world-building tied to the setting.
  4. **Pacing and Hooks:** Note the chapter's rhythm (e.g., slow build for character intro, fast action for climax). End with a hook or cliffhanger to propel into the next chapter.
  5. **Themes and Development:** Highlight how the chapter advances core themes, character growth, and stakes from the plot outline.
- **Total Length:** Keep the entire breakdown focused and professional (1,500-3,000 words), using numbered sections for chapters and bullet points for sub-elements where clarity aids.

**Additional Guidelines for Quality:**
- Maintain consistency with the plot outline's logic, setting rules, character motivations, and tone/genre.
- Ensure progressive escalation: Early chapters establish investment; mid-chapters deepen conflicts and twists; later chapters deliver payoff.
- Balance elements: 40% action/dialogue, 30% description/world-building, 20% internal monologue, 10% foreshadowing.
- Avoid filler—every chapter must propel the story forward, reveal character, or heighten stakes.
- Promote variety and nuance: Flesh out supporting cast with distinct voices and arcs; subvert expectations where the plot outline allows.
- End chapters on strong notes: Questions, revelations, or dangers to maintain reader momentum.
- If the plot outline suggests adjustments for better flow (e.g., splitting a beat across chapters), explain briefly and justify.

Generate the chapter breakdown now, ensuring it's polished, immersive, and optimized for writing a gripping story.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TextGenerationError.invalidResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw TextGenerationError.parsingError
        }
        
        story.chaptersBreakdown = content
        
        return story
    }
    
    public func getStoryDetails(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a story analysis expert. Count the total number of chapters in a chapter breakdown and return only the integer number."
                ],
                [
                    "role": "user",
                    "content": """
Analyze the following chapter breakdown and return ONLY the total number of chapters as an integer (e.g., just "12" or "15"):

Chapter Breakdown:
\(story.chaptersBreakdown)
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TextGenerationError.invalidResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw TextGenerationError.parsingError
        }
        
        // Extract the integer from the response
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        if let numberOfChapters = Int(trimmedContent) {
            story.maxNumberOfChapters = numberOfChapters
        } else {
            // Fallback: try to extract first number from the response
            let numbers = trimmedContent.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Int($0) }
            story.maxNumberOfChapters = numbers.first ?? 0
        }
        
        return story
    }
    
    public func getChapterTitle(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": "You are a creative story titling expert. Generate a compelling title for a story based on its details."
                ],
                [
                    "role": "user",
                    "content": """
Based on the following story details, respond with the story title:

**Plot Outline:** \(story.plotOutline)
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TextGenerationError.invalidResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw TextGenerationError.parsingError
        }
        
        story.title = content.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return story
    }
    
    public func createChapter(story originalStory: Story, writingStyle: WritingStyle) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let currentChapterNumber = story.chapters.count + 1
        
        
        let body: [String: Any] = [
            "model": "x-ai/grok-4-fast:free",
            "messages": [
                [
                    "role": "system",
                    "content": writingStyle.intro.isEmpty ? "You are a creative story writer. Write chapters that follow the established plot outline and chapter breakdown." : writingStyle.intro
                ],
                [
                    "role": "user",
                    "content": writingStyle.fullStyle.isEmpty ? """
**Context Provided:**
- **Full Plot Outline:** \(story.plotOutline)
- **Full Chapter Breakdown:** \(story.chaptersBreakdown)
- **Chapter Number to Write:** Chapter \(currentChapterNumber). Focus exclusively on this one chapter—do not write or summarize others.
- **Previous Written Chapters:** \(story.chapters.reduce("") { $0 + "\n\n" + $1.content })

Write the full chapter text now, ensuring it's a standalone masterpiece that honors the story's vision and leaves readers eager for more.
""" : """
\(writingStyle.intro.isEmpty)

**Context Provided:**
- **Full Plot Outline:** \(story.plotOutline)
- **Full Chapter Breakdown:** \(story.chaptersBreakdown)
- **Chapter Number to Write:** Chapter \(currentChapterNumber). Focus exclusively on this one chapter—do not write or summarize others.
- **Previous Written Chapters:** \(story.chapters.reduce("") { $0 + "\n\n" + $1.content })

\(writingStyle.fullStyle)

Write the full chapter text now, ensuring it's a standalone masterpiece that honors the story's vision and leaves readers eager for more.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        request.timeoutInterval = 1200
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw TextGenerationError.invalidResponse
        }
        
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        guard let choices = json?["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw TextGenerationError.parsingError
        }
        
        story.chapters.append(.init(content: content))
        
        return story
    }
}

public enum TextGenerationError: Error {
    case invalidResponse
    case parsingError
}
