//
//  ReaderView.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI
import UIKit

struct ReaderView: View {
    @EnvironmentObject var store: ReaderStore
    @State private var isMenuOpen: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var mainCharacter: String = ""
    @State private var settingDetails: String = ""
    @FocusState private var focusedField: Field?
    @State private var keyboardHeight: CGFloat = 0
    @State private var showStoryForm: Bool = false
    @State private var currentScrollOffset: CGFloat = 0
    @State private var scrollOffsetTimer: Timer?
    @State private var scrollViewHeight: CGFloat = 0
    
    enum Field {
        case mainCharacter
        case settingDetails
    }
    
    init() {
        
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            // Main content
            VStack(spacing: 0) {
                // Top bar with menu button
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "text.alignleft")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                            .padding()
                    }
                    
                    Spacer()
                }
                .background(Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.8))
                
                // Loading bar (appears below top bar when loading)
                if store.state.isLoading {
                    LoadingView(loadingStep: store.state.loadingStep, hasExistingStory: store.state.story != nil)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                ZStack {
                    if let story = store.state.story,
                       !story.chapters.isEmpty,
                       story.chapterIndex < story.chapters.count {
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
                                                .font(.custom("Georgia", size: 18))
                                                .lineSpacing(8)
                                                .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                                .padding(.horizontal, 32)
                                                .padding(.vertical, 40)
                                                .id("content")
                                            
                                            // Next Chapter Button (only show if more chapters can be created)
                                            if story.chapterIndex < story.maxNumberOfChapters - 1 {
                                                PrimaryButton(
                                                    title: "Next Chapter",
                                                    icon: "book.pages"
                                                ) {
                                                    store.dispatch(.createChapter(story))
                                                }
                                                .padding(.bottom, 40)
                                                .padding(.bottom, 80) // Additional space for navigation bar
                                                .disabled(store.state.isLoading)
                                            }
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
                                        }
                                    }
                                    .onAppear {
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
                                }
                            }
                            
                            // Chapter Navigation Bar
                            ChapterNavigationBar(story: story)
                        }
                    } else if !store.state.isLoading {
                        // Welcome state (only show when not loading)
                        ZStack {
                            // Tap background to dismiss form
                            if showStoryForm {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            showStoryForm = false
                                            focusedField = nil
                                        }
                                    }
                            }
                            
                            // Centered content (scroll icon and welcome text)
                            if focusedField == nil && !showStoryForm {
                                WelcomeView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .transition(.opacity)
                            }
                            
                            // Bottom content (input fields and button)
                            VStack {
                                Spacer()
                                
                                if !showStoryForm {
                                    // Initial "New Story" button
                                    NewStoryButton(showStoryForm: $showStoryForm)
                                        .padding(.bottom, 50)
                                        .transition(.asymmetric(
                                            insertion: .scale.combined(with: .opacity),
                                            removal: .scale.combined(with: .opacity)
                                        ))
                                } else {
                                    // Story form
                                    NewStoryForm(
                                        focusedField: $focusedField,
                                        showStoryForm: $showStoryForm
                                    )
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .move(edge: .bottom).combined(with: .opacity)
                                    ))
                                    .onTapGesture {
                                        // Prevent dismissal when tapping on the form itself
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .animation(.easeInOut(duration: 0.3), value: focusedField)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showStoryForm)
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                            keyboardHeight = 0
                        }
                        .onChange(of: store.state.isLoading) { _, isLoading in
                            if isLoading {
                                showStoryForm = false
                                focusedField = nil
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                .scrollBounceBehavior(.basedOnSize)
                .animation(.easeInOut(duration: 0.4), value: store.state.isLoading)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.startLocation.x < 20 && value.translation.width > 0 {
                            dragOffset = min(value.translation.width, 280)
                        }
                    }
                    .onEnded { value in
                        if dragOffset > 100 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isMenuOpen = true
                            }
                        }
                        dragOffset = 0
                    }
            )
            
            // Side menu overlay
            if isMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isMenuOpen = false
                        }
                    }
            }
            
            // Side menu
            StoryMenu(
                isMenuOpen: $isMenuOpen,
                dragOffset: dragOffset
            )
        }
        .onAppear {
            store.dispatch(.loadAllStories)
        }
//        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    private func startScrollOffsetTimer() {
        scrollOffsetTimer?.invalidate()
        scrollOffsetTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if let story = store.state.story,
                   abs(currentScrollOffset - story.scrollOffset) > 1 {
                    store.dispatch(.updateScrollOffset(currentScrollOffset))
                }
            }
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ReaderView()
}
