//
//  ChapterNavigationView.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import TextGeneration
import PapyrusStyleKit

struct ChapterNavigationView: View {
    @EnvironmentObject var store: ReaderStore
    let story: Story
    
    private var isOnLastChapterAndCanCreateNext: Bool {
        story.chapterIndex == story.chapters.count - 1 && 
        story.chapterIndex < story.maxNumberOfChapters - 1
    }
    
    private var isAutoCreatingNextChapter: Bool {
        isOnLastChapterAndCanCreateNext && store.state.isLoading
    }
    
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
                .foregroundColor(PapyrusColor.textSecondary.color)
                .frame(maxWidth: 200)
            
            // Next Chapter Button or Loading Spinner
            Group {
                if isAutoCreatingNextChapter {
                    // Show loading spinner when auto-creating next chapter
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: PapyrusColor.iconSecondary.color))
                        .scaleEffect(0.8)
                        .frame(width: 32, height: 32)
                } else {
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
        .onAppear {
            // Auto-trigger next chapter creation when viewing the last chapter
            if isOnLastChapterAndCanCreateNext && !store.state.isLoading {
                store.dispatch(.setAutoCreatingChapter(true, story))
            }
        }
        .onChange(of: story.chapterIndex) { _, _ in
            // Auto-trigger next chapter creation when navigating to the last chapter
            if isOnLastChapterAndCanCreateNext && !store.state.isLoading {
                store.dispatch(.setAutoCreatingChapter(true, story))
            }
        }
    }
}
