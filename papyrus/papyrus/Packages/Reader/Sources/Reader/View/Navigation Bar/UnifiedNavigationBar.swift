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
    @Environment(\.papyrusColorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Menu button (left)
                MenuButton(type: .menu) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        let newStatus: MenuStatus = store.state.menuStatus == .storyOpen ? .closed : .storyOpen
                        store.dispatch(.setMenuStatus(newStatus))
                    }
                }

                // Chapter navigation (center) - only show for non-interactive stories
                if let story = store.state.story,
                   story.mode != .interactive,
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
                        let newStatus: MenuStatus = store.state.menuStatus == .settingsOpen ? .closed : .settingsOpen
                        store.dispatch(.setMenuStatus(newStatus))
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .background(
            PapyrusColor.background.color(in: colorScheme)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}
