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
    @Environment(\.papyrusColorScheme) private var colorScheme
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

            // Story and Chapter Indicator
            Text("Chapter \(story.chapterIndex + 1) of \(story.maxNumberOfChapters > 0 ? story.maxNumberOfChapters : story.chapters.count)")
                .font(.custom(store.state.settingsState.selectedFontName, size: 12))
                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                .frame(maxWidth: 200)

            // Next Chapter Button
            if store.state.isLoading && story.chapterIndex == story.chapters.count - 1 {
                ProgressView()
                    .tint(PapyrusColor.iconPrimary.color(in: colorScheme))
                    .frame(width: 44, height: 44) // Match MenuButton frame
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
}
