//
//  ChapterNavigationView.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import TextGeneration

struct ChapterNavigationView: View {
    @EnvironmentObject var store: ReaderStore
    let story: Story
    
    var body: some View {
        HStack(spacing: 16) {
            // Previous Chapter Button
            MenuButton(
                type: .previous,
                isEnabled: story.chapterIndex > 0
            ) {
                if story.chapterIndex > 0 {
                    store.dispatch(.updateChapterIndex(story, story.chapterIndex - 1))
                }
            }
            
            // Chapter Indicator
            Text("Chapter \(story.chapterIndex + 1) of \(story.maxNumberOfChapters > 0 ? story.maxNumberOfChapters : story.chapters.count)")
                .font(.custom("Georgia", size: 12))
                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                .frame(maxWidth: 200)
            
            // Next Chapter Button
            MenuButton(
                type: .next,
                isEnabled: story.chapterIndex < story.chapters.count - 1
            ) {
                if story.chapterIndex < story.chapters.count - 1 {
                    store.dispatch(.updateChapterIndex(story, story.chapterIndex + 1))
                }
            }
        }
    }
}
