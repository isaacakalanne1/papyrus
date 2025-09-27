//
//  TextGenerationRepository.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 26/09/2025.
//

protocol TextGenerationRepositoryProtocol {
    func createChapter() -> String
}

public class TextGenerationRepository: TextGenerationRepositoryProtocol {
    public func createChapter() -> String {
        """
        Chapter 1: The Forgotten Library
        
        The ancient door creaked open with a sound like autumn leaves rustling in the wind. Maya stepped into the dimly lit chamber, her footsteps echoing against the stone walls that had stood for centuries. Dust motes danced in the shafts of golden light that filtered through the tall, arched windows.
        
        Before her stretched rows upon rows of towering bookshelves, their wooden frames darkened with age and mystery. Each shelf was packed with volumes bound in leather of every conceivable color—deep burgundy, forest green, midnight blue, and rich amber. Some books were so old their titles had faded to whispers of gold leaf on weathered spines.
        
        The air itself seemed to hum with stories untold. Maya could almost hear the voices of a thousand characters calling out from their printed pages, begging to be remembered once more. She ran her fingers along the nearest shelf, feeling the raised letters and worn edges of books that had been loved and treasured by generations of readers.
        
        As she ventured deeper into the library, she noticed something peculiar. While most of the books were clearly ancient, there were newer volumes scattered throughout—their bindings crisp and bright, as if they had appeared overnight. Their pages seemed to shimmer with an otherworldly light, and when Maya leaned closer, she could swear she heard the faint sound of typing, as if invisible hands were still writing their stories.
        
        "Welcome," came a gentle voice from somewhere among the stacks. "I've been waiting for someone who truly loves stories to find this place."
        
        Maya turned, her heart racing with anticipation. This was only the beginning of an adventure she could never have imagined, in a library where every book held the power to change not just her world, but worlds beyond counting.
        """
    }
}
