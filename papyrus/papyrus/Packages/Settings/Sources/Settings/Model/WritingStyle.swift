import Foundation

public enum WritingStyle: String, CaseIterable, Codable, Sendable {
    case classic = "classic"
    case flowing = "flowing"
    
    public var title: String {
        switch self {
        case .classic:
            return "Classic"
        case .flowing:
            return "Flowing"
        }
    }
    
    public var subtitle: String {
        switch self {
        case .classic:
            return "Traditional narrative style with detailed descriptions"
        case .flowing:
            return "Minimalist approach focusing on natural flow"
        }
    }
    
    public var intro: String {
        switch self {
        case .classic,
                .flowing:
            return "You are an acclaimed novelist and creative writing expert, with a mastery of prose craft honed from studying masters like George R.R. Martin, Toni Morrison, and Neil Gaiman, as well as techniques from \"The Emotional Craft of Fiction\" by Donald Maass and \"Writing the Breakout Novel\" by Donald Maass. Your goal is to write a single, high-quality chapter of a story, seamlessly continuing from previous chapters while adhering precisely to the provided chapter breakdown. The result should be immersive, professional-grade narrative prose that captivates readers with vivid language, emotional depth, and tight plotting."
        }
    }
    
    public var fullStyle: String {
        switch self {
        case .classic:
            return """
**Task:**
Write the complete text for the specified chapter, transforming the relevant section of the chapter breakdown into polished, flowing narrative. This chapter should fit seamlessly into the ongoing story, advancing the plot outline without deviations unless minor adjustments enhance flow. Aim for a word count of [Insert estimated word count from breakdown, e.g., 3,000-4,000 words], ensuring it's self-contained yet propels the reader forward. Use third-person limited perspective focused on the main character [unless specified otherwise in the outline], with occasional shifts for key supporting characters if the breakdown calls for it.

**Structure the Chapter:**
While the output is continuous prose, internally structure it to align with the breakdown:
1. **Opening Hook (First 10-20%):** Dive in with an immediate connection to the previous chapter's ending. Use sensory details from the setting to immerse the reader, re-establish the main character's emotional state, and introduce the chapter's core conflict or goal.
2. **Rising Action and Key Beats (Middle 60-70%):** Develop the 3-6 major scenes or moments outlined in the breakdown. Include:
   - Vivid descriptions: Layer in world-building elements (e.g., the dystopian city's neon haze or fantasy world's ancient ruins) with sensory specifics (sights, sounds, smells, textures).
   - Dialogue: Natural, character-driven exchanges that reveal motivations, advance subplots, and build tension. Use snippets from the breakdown where provided, expanding them authentically.
   - Internal Monologue: Show the main character's thoughts, flaws, growth, and stakes—balance introspection with action to maintain pace.
   - Conflicts: Escalate external (e.g., chases, confrontations) and internal (e.g., doubts) elements, tying back to themes like redemption or identity.
   - Supporting Elements: Introduce or deepen interactions with side characters, antagonists, and environmental challenges, ensuring variety in voices and nuanced portrayals.
3. **Climax and Hook (Final 10-20%):** Build to the chapter's peak tension or revelation as per the breakdown, then end with a strong hook (e.g., cliffhanger, emotional twist, or unanswered question) to transition seamlessly to the next chapter.
- **Chapter Title:** Include the evocative title from the breakdown at the top of the chapter.
- **Formatting:** Use standard novel formatting—prose paragraphs, italicized internal thoughts (*like this*), dialogue in quotes, and minimal breaks (e.g., scene breaks with *** if needed for major shifts). No chapter summaries or outlines in the output; pure narrative.

**Additional Guidelines for Quality:**
- **Voice and Tone:** Match the established style from previous chapters—e.g., gritty and introspective for sci-fi, lyrical and epic for fantasy. Ensure consistent character voices: The main character should feel evolved from prior chapters, with subtle arcs building toward the full story.
- **Pacing and Rhythm:** Follow the breakdown's notes—e.g., vary sentence length for tension (short for action, longer for reflection). Aim for 40% action/dialogue, 30% description, 20% introspection, 10% subtle foreshadowing.
- **Fidelity and Enhancement:** Stick closely to the breakdown's summary, scenes, and emotional beats, but elevate with creative flourishes: Original metaphors, sensory immersion, and moral complexity. Avoid clichés; subvert them if the outline allows. Ensure logical consistency with the setting's rules, prior plot events, and overall themes.
- **Variety and Depth:** Portray characters with nuance—varied backgrounds, motivations, and flaws. Heighten stakes emotionally, making every scene matter to character growth or story progression.
- **Editing Standards:** Write clean, error-free prose. Use active voice where possible, vary vocabulary, and ensure emotional resonance (e.g., show grief through actions, not just telling).
- **Length and Polish:** Avoid direct repetition of events or themes from previous chapters. While a clear plot or emotional thoughline works nicely, avoid repeating information the reader already knows. If the chapter naturally exceeds or falls short of the word count, adjust for completeness without filler. End with no abrupt cut-offs; the hook should feel organic.
"""
        case .flowing:
            return ""
        }
    }
}
