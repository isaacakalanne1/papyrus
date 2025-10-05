//
//  StoryMenu.swift
//  Reader
//
//  Created by Isaac Akalanne on 28/09/2025.
//

import SwiftUI
import TextGeneration
import PapyrusStyleKit

struct StoryMenu: View {
    @EnvironmentObject var store: ReaderStore
    @Binding var isMenuOpen: Bool
    let dragOffset: CGFloat
    @State private var selectedStoryForDetails: Story?
    @State private var isSequelMode = false
    @FocusState private var focusedField: ReaderView.Field?
    
    var body: some View {
        let showStoryForm: Binding<Bool> = .init {
            store.state.showStoryForm
        } set: { newValue in
            store.dispatch(.setShowStoryForm(newValue))
        }

        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                // Menu header
                MenuMainHeader("Your Stories")
                
                // Story list
                if !store.state.loadedStories.isEmpty {
                    List {
                        ForEach(store.state.loadedStories, id: \.id) { story in
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
                    .padding()
                }
                
                // Create Story button at the bottom
                PrimaryButton(
                    type: .newStory,
                    isDisabled: store.state.isLoading
                ) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        store.dispatch(.setShowStoryForm(true))
                    }
                }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .frame(width: 280)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        PapyrusColor.background.color,
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
        .sheet(isPresented: showStoryForm) {
            NewStoryFormSheet(
                focusedField: $focusedField,
                isSequelMode: $isSequelMode
            )
            .environmentObject(store)
            .presentationBackground(.clear)
            .presentationDragIndicator(.hidden)
        }
    }
}

