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
    let menuStatus: ReaderView.MenuStatus
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
                    isDisabled: false,
                    isLoading: store.state.isLoading
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
            .offset(x: calculateOffset())
            
            Spacer()
        }
        .sheet(item: Binding(
            get: { store.state.selectedStoryForDetails },
            set: { store.dispatch(.setSelectedStoryForDetails($0)) }
        )) { story in
            StoryDetailsPopup(story: story, isPresented: Binding(
                get: { store.state.selectedStoryForDetails != nil },
                set: { if !$0 { store.dispatch(.setSelectedStoryForDetails(nil)) } }
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
    
    private func calculateOffset() -> CGFloat {
        switch menuStatus {
        case .storyOpen:
            // Menu is open, allow closing gesture
            return min(0, dragOffset)
        case .settingsOpen:
            // Settings is open, keep menu offscreen
            return -280
        case .closed:
            // Both closed, only respond to positive drag (opening gesture)
            return -280 + max(0, dragOffset)
        }
    }
}
