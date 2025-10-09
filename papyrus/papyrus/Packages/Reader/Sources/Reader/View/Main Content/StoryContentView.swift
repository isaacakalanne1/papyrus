//
//  StoryContentView.swift
//  Reader
//
//  Created by Isaac Akalanne on 29/09/2025.
//

import SwiftUI
import TextGeneration
import Settings

struct StoryContentView: View {
    let story: Story
    @EnvironmentObject var store: ReaderStore
    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var isSequelMode: Bool
    @Binding var currentScrollOffset: CGFloat
    @Binding var scrollViewHeight: CGFloat
    
    let startScrollOffsetTimer: () -> Void
    
    private func setupStoryView(with proxy: ScrollViewProxy, scrollGeometry: GeometryProxy) {
        scrollViewHeight = scrollGeometry.size.height
        startScrollOffsetTimer()
        // Scroll to saved position
        if story.scrollOffset > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // To scroll down by X points, we position the top anchor at -X/scrollViewHeight
                let actualScrollHeight = scrollViewHeight > 0 ? scrollViewHeight : UIScreen.main.bounds.height
                let anchorY = -(story.scrollOffset / actualScrollHeight)
                proxy.scrollTo("topAnchor", anchor: UnitPoint(x: 0, y: anchorY))
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                GeometryReader { scrollGeometry in
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 0) {
                                // Geometry reader at the very top to track scroll offset
                                GeometryReader { geometry in
                                    Color.clear
                                        .preference(key: ScrollOffsetPreferenceKey.self,
                                                    value: -geometry.frame(in: .named("scroll")).minY)
                                }
                                .frame(height: 0)
                                .id("topAnchor")
                                
                                // Content
                                Text(story.chapters[story.chapterIndex].content)
                                    .font(.custom("Georgia", size: store.state.settingsState.selectedTextSize.fontSize))
                                    .lineSpacing(8)
                                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 40)
                                    .id("content")
                                
                                // Next Chapter or Create Sequel Button
                                Group {
                                    if story.chapterIndex < story.maxNumberOfChapters - 1 && story.chapterIndex >= story.chapters.count - 1 {
                                        PrimaryButton(
                                            type: .nextChapter,
                                            isDisabled: store.state.isLoading,
                                            isLoading: store.state.isLoading
                                        ) {
                                            store.dispatch(.createChapter(story))
                                        }
                                        .disabled(store.state.isLoading)
                                    } else if story.chapterIndex == story.maxNumberOfChapters - 1 {
                                        PrimaryButton(
                                            type: .createSequel,
                                            isDisabled: store.state.isLoading,
                                            isLoading: store.state.isLoading
                                        ) {
                                            isSequelMode = true
                                            store.dispatch(.updateMainCharacter(story.mainCharacter))
                                            store.dispatch(.updateSetting(""))
                                            store.dispatch(.setShowStoryForm(true))
                                            focusedField = .settingDetails
                                        }
                                        .disabled(store.state.isLoading)
                                    }
                                }
                                .padding(.bottom, 30)
                            }
                        }
                        .coordinateSpace(name: "scroll")
                        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                            DispatchQueue.main.async {
                                currentScrollOffset = value
                            }
                        }
                        .onChange(of: story.chapterIndex) { oldValue, newValue in
                            if oldValue != newValue {
                                proxy.scrollTo("content", anchor: .top)
                                currentScrollOffset = 0
                            }
                        }
                        .onChange(of: story.id, { oldValue, newValue in
                            setupStoryView(with: proxy, scrollGeometry: scrollGeometry)
                        })
                        .onAppear {
                            setupStoryView(with: proxy, scrollGeometry: scrollGeometry)
                        }
                    }
                }
            }
            
            // Close button positioned at top right
            MenuButton(type: .close) {
                store.dispatch(.setStory(nil))
            }
            .padding(16)
        }
    }
}
