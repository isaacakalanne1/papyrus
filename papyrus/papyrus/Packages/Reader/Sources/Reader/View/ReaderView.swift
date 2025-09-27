//
//  ReaderView.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI

public struct ReaderView: View {
    let exampleChapter = """
    Chapter 1: The Forgotten Library
    
    The ancient door creaked open with a sound like autumn leaves rustling in the wind. Maya stepped into the dimly lit chamber, her footsteps echoing against the stone walls that had stood for centuries. Dust motes danced in the shafts of golden light that filtered through the tall, arched windows.
    
    Before her stretched rows upon rows of towering bookshelves, their wooden frames darkened with age and mystery. Each shelf was packed with volumes bound in leather of every conceivable color—deep burgundy, forest green, midnight blue, and rich amber. Some books were so old their titles had faded to whispers of gold leaf on weathered spines.
    
    The air itself seemed to hum with stories untold. Maya could almost hear the voices of a thousand characters calling out from their printed pages, begging to be remembered once more. She ran her fingers along the nearest shelf, feeling the raised letters and worn edges of books that had been loved and treasured by generations of readers.
    
    As she ventured deeper into the library, she noticed something peculiar. While most of the books were clearly ancient, there were newer volumes scattered throughout—their bindings crisp and bright, as if they had appeared overnight. Their pages seemed to shimmer with an otherworldly light, and when Maya leaned closer, she could swear she heard the faint sound of typing, as if invisible hands were still writing their stories.
    
    "Welcome," came a gentle voice from somewhere among the stacks. "I've been waiting for someone who truly loves stories to find this place."
    
    Maya turned, her heart racing with anticipation. This was only the beginning of an adventure she could never have imagined, in a library where every book held the power to change not just her world, but worlds beyond counting.
    """
    
    public init() {
        
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text(exampleChapter)
                    .font(.custom("Georgia", size: 18))
                    .lineSpacing(8)
                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.89),
                    Color(red: 0.96, green: 0.92, blue: 0.84)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    ReaderView()
}
