//
//  StoryMenu.swift
//  Reader
//
//  Created by Isaac Akalanne on 28/09/2025.
//

import SwiftUI
import TextGeneration

struct StoryMenu: View {
    @EnvironmentObject var store: ReaderStore
    @Binding var isMenuOpen: Bool
    let dragOffset: CGFloat
    @State private var selectedStoryForDetails: Story?
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                // Menu header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Stories")
                        .font(.custom("Georgia", size: 24))
                        .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                    
                    Divider()
                        .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.5))
                }
                .padding()
                .padding(.top, 20)
                
                // Story list
                if let stories = store.state.loadedStories, !stories.isEmpty {
                    List {
                        ForEach(stories, id: \.id) { story in
                            Button(action: {
                                store.dispatch(.setStory(story))
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isMenuOpen = false
                                }
                            }) {
                                HStack {
                                    Image(systemName: "book.closed")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(story.title.isEmpty ? "Untitled Story" : story.title)
                                            .font(.custom("Georgia", size: 16))
                                            .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                                            .lineLimit(1)
                                        
                                        if !story.chapters.isEmpty {
                                            Text("\(story.chapters.count) chapter\(story.chapters.count == 1 ? "" : "s")")
                                                .font(.custom("Georgia", size: 12))
                                                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        selectedStoryForDetails = story
                                    }) {
                                        Image(systemName: "info.circle")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .listRowBackground(
                                Color(red: 0.6, green: 0.5, blue: 0.4)
                                    .opacity(story.id == store.state.story?.id ? 0.15 : 0)
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
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                } else {
                    VStack {
                        Spacer()
                        Text("No saved stories yet")
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .frame(width: 280)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.98, green: 0.95, blue: 0.89),
                        Color(red: 0.96, green: 0.92, blue: 0.84)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .offset(x: isMenuOpen ? 0 : -280 + dragOffset)
            
            Spacer()
        }
        .sheet(item: $selectedStoryForDetails) { story in
            StoryDetailsPopup(story: story, isPresented: Binding(
                get: { selectedStoryForDetails != nil },
                set: { if !$0 { selectedStoryForDetails = nil } }
            ))
                .presentationBackground(.clear)
                .presentationDragIndicator(.hidden)
        }
    }
}

