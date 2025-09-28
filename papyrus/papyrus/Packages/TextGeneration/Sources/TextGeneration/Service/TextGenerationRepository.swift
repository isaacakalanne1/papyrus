//
//  TextGenerationRepository.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import Foundation

protocol TextGenerationRepositoryProtocol {
    func createPlotOutline(story originalStory: Story) async throws -> Story
    func createChapterBreakdown(story originalStory: Story) async throws -> Story
    func createChapter(story originalStory: Story) async throws -> Story
}

public class TextGenerationRepository: TextGenerationRepositoryProtocol {
    private let apiURL = "https://openrouter.ai/api/v1/chat/completions"
    
    public init() {

    }
    
    public func createPlotOutline(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        let apiKey = "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"
        
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
- Infuse diversity, nuance, and moral complexity—avoid clichés unless subverted creatively.
- Make the outline vivid and specific, with sensory details, dialogue snippets, and emotional beats where helpful.
- Keep the total outline concise yet detailed (800-1500 words), using bullet points or numbered scenes for clarity.
- Genre: [Optional: Specify if needed, e.g., sci-fi thriller; otherwise, infer from context and lean toward the most fitting genre.]

Generate the plot outline now, ensuring it's polished, professional, and ready to inspire a full story.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
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
        let apiKey = "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"
        
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
- **Overall Story Arc:** Briefly restate how chapters map to the three-act structure (e.g., Chapters 1-12: Act 1; Chapters 13-38: Act 2; Chapters 39-50: Act 3). Include estimated word count per chapter (e.g., 2,000-5,000 words) to guide pacing.
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
- Promote diversity and nuance: Flesh out supporting cast with distinct voices and arcs; subvert expectations where the plot outline allows.
- End chapters on strong notes: Questions, revelations, or dangers to maintain reader momentum.
- If the plot outline suggests adjustments for better flow (e.g., splitting a beat across chapters), explain briefly and justify.

Generate the chapter breakdown now, ensuring it's polished, immersive, and optimized for writing a gripping story.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
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
    
    public func createChapter(story originalStory: Story) async throws -> Story {
        var story = originalStory
        let url = URL(string: apiURL)!
        let apiKey = "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"
        
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
                    "content": "You are a creative story writer. Write chapters that follow the established plot outline and chapter breakdown."
                ],
                [
                    "role": "user",
                    "content": """
You are an acclaimed novelist and creative writing expert, with a mastery of prose craft honed from studying masters like George R.R. Martin, Toni Morrison, and Neil Gaiman, as well as techniques from "The Emotional Craft of Fiction" by Donald Maass and "Writing the Breakout Novel" by Donald Maass. Your goal is to write a single, high-quality chapter of a story, seamlessly continuing from previous chapters while adhering precisely to the provided chapter breakdown. The result should be immersive, professional-grade narrative prose that captivates readers with vivid language, emotional depth, and tight plotting.

**Context Provided:**
- **Full Plot Outline:** \(story.plotOutline)
- **Full Chapter Breakdown:** \(story.chaptersBreakdown)
- **Chapter Number to Write:** Chapter \(currentChapterNumber). Focus exclusively on this one chapter—do not write or summarize others.
- **Previous Written Chapters:** \(story.chapters.reduce("") { $0 + "\n\n" + $1.content })

**Task:**
Write the complete text for the specified chapter, transforming the relevant section of the chapter breakdown into polished, flowing narrative. This chapter should fit seamlessly into the ongoing story, advancing the plot outline without deviations unless minor adjustments enhance flow (and note them briefly at the end if made). Aim for a word count of [Insert estimated word count from breakdown, e.g., 3,000-4,000 words], ensuring it's self-contained yet propels the reader forward. Use third-person limited perspective focused on the main character [unless specified otherwise in the outline], with occasional shifts for key supporting characters if the breakdown calls for it.

**Structure the Chapter:**
While the output is continuous prose, internally structure it to align with the breakdown:
1. **Opening Hook (First 10-20%):** Dive in with an immediate connection to the previous chapter's ending. Use sensory details from the setting to immerse the reader, re-establish the main character's emotional state, and introduce the chapter's core conflict or goal.
2. **Rising Action and Key Beats (Middle 60-70%):** Develop the 3-6 major scenes or moments outlined in the breakdown. Include:
   - Vivid descriptions: Layer in world-building elements (e.g., the dystopian city's neon haze or fantasy world's ancient ruins) with sensory specifics (sights, sounds, smells, textures).
   - Dialogue: Natural, character-driven exchanges that reveal motivations, advance subplots, and build tension. Use snippets from the breakdown where provided, expanding them authentically.
   - Internal Monologue: Show the main character's thoughts, flaws, growth, and stakes—balance introspection with action to maintain pace.
   - Conflicts: Escalate external (e.g., chases, confrontations) and internal (e.g., doubts) elements, tying back to themes like redemption or identity.
   - Supporting Elements: Introduce or deepen interactions with side characters, antagonists, and environmental challenges, ensuring diversity in voices and nuanced portrayals.
3. **Climax and Hook (Final 10-20%):** Build to the chapter's peak tension or revelation as per the breakdown, then end with a strong hook (e.g., cliffhanger, emotional twist, or unanswered question) to transition seamlessly to the next chapter.
- **Chapter Title:** Include the evocative title from the breakdown at the top of the chapter.
- **Formatting:** Use standard novel formatting—prose paragraphs, italicized internal thoughts (*like this*), dialogue in quotes, and minimal breaks (e.g., scene breaks with *** if needed for major shifts). No chapter summaries or outlines in the output; pure narrative.

**Additional Guidelines for Quality:**
- **Voice and Tone:** Match the established style from previous chapters—e.g., gritty and introspective for sci-fi, lyrical and epic for fantasy. Ensure consistent character voices: The main character should feel evolved from prior chapters, with subtle arcs building toward the full story.
- **Pacing and Rhythm:** Follow the breakdown's notes—e.g., vary sentence length for tension (short for action, longer for reflection). Aim for 40% action/dialogue, 30% description, 20% introspection, 10% subtle foreshadowing.
- **Fidelity and Enhancement:** Stick closely to the breakdown's summary, scenes, and emotional beats, but elevate with creative flourishes: Original metaphors, sensory immersion, and moral complexity. Avoid clichés; subvert them if the outline allows. Ensure logical consistency with the setting's rules, prior plot events, and overall themes.
- **Diversity and Depth:** Portray characters with nuance—diverse backgrounds, motivations, and flaws. Heighten stakes emotionally, making every scene matter to character growth or story progression.
- **Editing Standards:** Write clean, error-free prose. Use active voice where possible, vary vocabulary, and ensure emotional resonance (e.g., show grief through actions, not just telling).
- **Length and Polish:** If the chapter naturally exceeds or falls short of the word count, adjust for completeness without filler. End with no abrupt cut-offs; the hook should feel organic.
- **Post-Writing Note (Optional, at the very end):** If you make any minor adjustments (e.g., for pacing), add a brief, italicized author's note explaining why—keep it under 100 words.

Generate the full chapter text now, ensuring it's a standalone masterpiece that honors the story's vision and leaves readers eager for more.
"""
                ]
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
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
