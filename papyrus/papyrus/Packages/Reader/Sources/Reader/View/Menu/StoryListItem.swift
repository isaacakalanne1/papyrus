//
//  StoryListItem.swift
//  Reader
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI
import TextGeneration
import PapyrusStyleKit

struct StoryListItem: View {
    let story: Story
    let isSelected: Bool
    let onTap: () -> Void

    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: "book.closed")
                    .font(.system(size: 16))
                    .foregroundColor(PapyrusColor.iconPrimary.color(in: colorScheme))

                VStack(alignment: .leading, spacing: 2) {
                    Text(story.title.isEmpty ? "Untitled Story" : story.title)
                        .font(.custom(store.state.settingsState.selectedFontName, size: 16))
                        .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                        .lineLimit(1)

                    if !story.chapters.isEmpty {
                        Text("\(story.chapters.count) chapter\(story.chapters.count == 1 ? "" : "s")")
                            .font(.custom(store.state.settingsState.selectedFontName, size: 12))
                            .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                    }
                }

                Spacer()

                Button(action: {
                    store.dispatch(.setSelectedStoryForDetails(story))
                }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 20))
                        .foregroundColor(PapyrusColor.iconPrimary.color(in: colorScheme))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listRowBackground(
            PapyrusColor.iconPrimary.color(in: colorScheme)
                .opacity(isSelected ? 0.15 : 0)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                store.dispatch(.confirmDeleteStory(story))
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
