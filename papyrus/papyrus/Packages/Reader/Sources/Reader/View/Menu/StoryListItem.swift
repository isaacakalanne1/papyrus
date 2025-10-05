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
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: "book.closed")
                    .font(.system(size: 16))
                    .foregroundColor(PapyrusColor.iconPrimary.color)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(story.title.isEmpty ? "Untitled Story" : story.title)
                        .font(.custom("Georgia", size: 16))
                        .foregroundColor(PapyrusColor.textPrimary.color)
                        .lineLimit(1)
                    
                    if !story.chapters.isEmpty {
                        Text("\(story.chapters.count) chapter\(story.chapters.count == 1 ? "" : "s")")
                            .font(.custom("Georgia", size: 12))
                            .foregroundColor(PapyrusColor.textSecondary.color)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    store.dispatch(.setSelectedStoryForDetails(story))
                }) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 20))
                        .foregroundColor(PapyrusColor.iconPrimary.color)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .listRowBackground(
            PapyrusColor.iconPrimary.color
                .opacity(isSelected ? 0.15 : 0)
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                store.dispatch(.deleteStory(story.id))
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}