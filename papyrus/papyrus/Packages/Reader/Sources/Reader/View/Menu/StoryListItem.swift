//
//  StoryListItem.swift
//  Reader
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import PapyrusStyleKit
import SwiftUI
import TextGeneration

struct StoryListItem: View {
    let story: Story
    let isSelected: Bool
    let onTap: () -> Void

    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme
    @State private var isExpanded = false

    private var fontName: String {
        store.state.settingsState.selectedFontName
    }

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: story.mode == .interactive ? "pencil" : "book.closed")
                        .font(.system(size: 16))
                        .foregroundColor(PapyrusColor.iconPrimary.color(in: colorScheme))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(story.title.isEmpty ? "Untitled Story" : story.title)
                            .font(.custom(fontName, size: 16))
                            .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                            .lineLimit(1)

                        if !story.chapters.isEmpty {
                            let count = story.chapters.count
                            let label = story.mode == .interactive ? "entr\(count == 1 ? "y" : "ies")" : "chapter\(count == 1 ? "" : "s")"
                            Text("\(count) \(label)")
                                .font(.custom(fontName, size: 12))
                                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                        }
                    }

                    Spacer()

                    if !story.chapters.isEmpty && story.mode != .interactive {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isExpanded.toggle()
                            }
                        }) {
                            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                                .font(.system(size: 14))
                                .foregroundColor(PapyrusColor.iconPrimary.color(in: colorScheme))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }

                    Button(action: {
                        store.dispatch(.setSelectedStoryForDetails(story))
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(PapyrusColor.iconPrimary.color(in: colorScheme))
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                if isExpanded {
                    VStack(spacing: 0) {
                        ForEach(Array(story.chapters.enumerated()), id: \.element.id) { index, chapter in
                            ChapterListItem(chapter: chapter, fontName: fontName) {
                                store.dispatch(.setStory(story))
                                store.dispatch(.updateChapterIndex(story, index))
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    store.dispatch(.setMenuStatus(.closed))
                                }
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(PapyrusColor.iconPrimary.color(in: colorScheme)
                        .opacity(isSelected ? 0.15 : 0.07))
            )
        }
        .listRowBackground(Color.clear)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                store.dispatch(.confirmDeleteStory(story))
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
