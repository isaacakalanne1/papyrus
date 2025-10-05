//
//  UnifiedNavigationBar.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import SwiftUI
import TextGeneration
import PapyrusStyleKit

struct UnifiedNavigationBar: View {
    @EnvironmentObject var store: ReaderStore
    @Binding var isMenuOpen: Bool
    @Binding var isSettingsOpen: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Menu button (left)
                MenuButton(type: .menu) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isMenuOpen.toggle()
                    }
                }
                
                // Chapter navigation (center) - only show when story exists
                if let story = store.state.story,
                   !story.chapters.isEmpty,
                   story.chapterIndex < story.chapters.count {
                    Spacer()
                    
                    ChapterNavigationView(story: story)
                    
                    Spacer()
                } else {
                    Spacer()
                }
                
                // Settings button (right)
                MenuButton(type: .settings) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isSettingsOpen.toggle()
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(PapyrusColor.background.color.opacity(0.95))
            
            Divider()
                .background(PapyrusColor.iconPrimary.color.opacity(0.3))
        }
    }
}
