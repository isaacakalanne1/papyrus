//
//  UnifiedNavigationBar.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import SwiftUI
import TextGeneration

struct UnifiedNavigationBar: View {
    @EnvironmentObject var store: ReaderStore
    @Binding var isMenuOpen: Bool
    @Binding var isSettingsOpen: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Menu button (left)
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMenuOpen.toggle()
                    }
                }) {
                    Image(systemName: "text.alignleft")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                        .frame(width: 44, height: 44)
                }
                
                // Chapter navigation (center) - only show when story exists
                if let story = store.state.story,
                   !story.chapters.isEmpty,
                   story.chapterIndex < story.chapters.count {
                    Spacer()
                    
                    HStack(spacing: 16) {
                        // Previous Chapter Button
                        Button(action: {
                            if story.chapterIndex > 0 {
                                store.dispatch(.updateChapterIndex(story, story.chapterIndex - 1))
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(
                                    story.chapterIndex > 0 
                                    ? Color(red: 0.4, green: 0.35, blue: 0.3)
                                    : Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3)
                                )
                                .frame(width: 32, height: 32)
                        }
                        .disabled(story.chapterIndex <= 0)
                        
                        // Chapter Indicator
                        VStack(spacing: 2) {
                            if !story.chapters[story.chapterIndex].title.isEmpty {
                                Text(story.chapters[story.chapterIndex].title)
                                    .font(.custom("Georgia", size: 14))
                                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            Text("Chapter \(story.chapterIndex + 1) of \(story.maxNumberOfChapters > 0 ? story.maxNumberOfChapters : story.chapters.count)")
                                .font(.custom("Georgia", size: 12))
                                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                        }
                        .frame(maxWidth: 200)
                        
                        // Next Chapter Button
                        Button(action: {
                            if story.chapterIndex < story.chapters.count - 1 {
                                store.dispatch(.updateChapterIndex(story, story.chapterIndex + 1))
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(
                                    story.chapterIndex < story.chapters.count - 1
                                    ? Color(red: 0.4, green: 0.35, blue: 0.3)
                                    : Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3)
                                )
                                .frame(width: 32, height: 32)
                        }
                        .disabled(story.chapterIndex >= story.chapters.count - 1)
                    }
                    
                    Spacer()
                } else {
                    Spacer()
                }
                
                // Settings button (right)
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSettingsOpen.toggle()
                    }
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.95))
            
            Divider()
                .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3))
        }
    }
}