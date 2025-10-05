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
                            StoryListItem(
                                story: story,
                                isSelected: story.id == store.state.story?.id,
                                onTap: {
                                    store.dispatch(.setStory(story))
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isMenuOpen = false
                                    }
                                },
                                onInfo: {
                                    selectedStoryForDetails = story
                                },
                                onDelete: {
                                    store.dispatch(.deleteStory(story.id))
                                }
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                } else {
                    NoStoriesView()
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
                        PapyrusColor.backgroundSecondary.color
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
