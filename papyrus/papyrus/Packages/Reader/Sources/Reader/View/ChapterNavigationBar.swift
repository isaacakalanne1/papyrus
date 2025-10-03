//
//  ChapterNavigationBar.swift
//  Reader
//
//  Created by Isaac Akalanne on 28/09/2025.
//

import SwiftUI
import TextGeneration

struct ChapterNavigationBar: View {
    @EnvironmentObject var store: ReaderStore
    let story: Story
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3))
            
            VStack(spacing: 4) {
                // Chapter Title
                if !story.chapters[story.chapterIndex].title.isEmpty {
                    Text(story.chapters[story.chapterIndex].title)
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.horizontal, 60) // Space for nav buttons
                }
                
                HStack(spacing: 40) {
                    // Previous Chapter Button
                    Button(action: {
                        if story.chapterIndex > 0 {
                            store.dispatch(.updateChapterIndex(story, story.chapterIndex - 1))
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(
                                story.chapterIndex > 0 
                                ? Color(red: 0.4, green: 0.35, blue: 0.3)
                                : Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3)
                            )
                            .frame(width: 44, height: 44)
                    }
                    .disabled(story.chapterIndex <= 0)
                    
                    // Chapter Indicator
                    Text("Chapter \(story.chapterIndex + 1) of \(story.maxNumberOfChapters > 0 ? story.maxNumberOfChapters : story.chapters.count)")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                    
                    // Next Chapter Button
                    Button(action: {
                        if story.chapterIndex < story.chapters.count - 1 {
                            store.dispatch(.updateChapterIndex(story, story.chapterIndex + 1))
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(
                                story.chapterIndex < story.chapters.count - 1
                                ? Color(red: 0.4, green: 0.35, blue: 0.3)
                                : Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3)
                            )
                            .frame(width: 44, height: 44)
                    }
                    .disabled(story.chapterIndex >= story.chapters.count - 1)
                }
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.95)
            )
        }
    }
}