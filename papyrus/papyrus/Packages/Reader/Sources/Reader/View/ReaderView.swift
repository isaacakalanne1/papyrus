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
                
                ZStack {
                    if store.state.isLoading {
                        LoadingView()
                            .transition(.opacity)
                    } else if let story = store.state.story,
                              !story.chapters.isEmpty,
                              story.chapterIndex < story.chapters.count {
                        VStack(spacing: 0) {
                            ScrollView {
                                Text(story.chapters[story.chapterIndex].content)
                                    .font(.custom("Georgia", size: 18))
                                    .lineSpacing(8)
                                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                    .padding(.horizontal, 32)
                                    .padding(.vertical, 40)
                                    .padding(.bottom, 80) // Space for navigation bar
                            }
                            
                            // Chapter Navigation Bar
                            VStack(spacing: 0) {
                                Divider()
                                    .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3))
                                
                                VStack(spacing: 4) {
                                    // Chapter Title
                                    if !story.chapters[story.chapterIndex].title.isEmpty {
                                        Text(story.chapters[story.chapterIndex].title)
                                            .font(.custom("Georgia", size: 16))
                                            .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                            .padding(.horizontal, 60) // Space for nav buttons
                                    }
                                    
                                    HStack(spacing: 40) {
                                        // Previous Chapter Button
                                        Button(action: {
                                            if story.chapterIndex > 0 {
                                                store.dispatch(.updateChapterIndex(story.chapterIndex - 1))
                                            }
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(
                                                    story.chapterIndex > 0 
                                                    ? Color(red: 0.4, green: 0.35, blue: 0.3)
                                                    : Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3)
                                                )
                                                .frame(width: 44, height: 44)
                                        }
                                        .disabled(story.chapterIndex <= 0)
                                        
                                        // Chapter Indicator
                                        Text("Chapter \(story.chapterIndex + 1) of \(story.chapters.count)")
                                            .font(.custom("Georgia", size: 14))
                                            .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                                        
                                        // Next Chapter Button
                                        Button(action: {
                                            if story.chapterIndex < story.chapters.count - 1 {
                                                store.dispatch(.updateChapterIndex(story.chapterIndex + 1))
                                            }
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(
                                                    story.chapterIndex < story.chapters.count - 1
                                                    ? Color(red: 0.4, green: 0.35, blue: 0.3)
                                                    : Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3)
                                                )
                                                .frame(width: 44, height: 44)
                                        }
                                        .disabled(story.chapterIndex >= story.chapters.count - 1)
                                    }
                                }
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(
                                    Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.95)
                                )
                            }
                        }
                    } else {
                        // Welcome state
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
                        .onChange(of: store.state.isLoading) { isLoading in
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
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            if let stories = store.state.loadedStories, !stories.isEmpty {
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
                                            
                                            Text(story.title.isEmpty ? "Untitled Story" : story.title)
                                                .font(.custom("Georgia", size: 16))
                                                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                    }
                                    .background(
                                        Color(red: 0.6, green: 0.5, blue: 0.4)
                                            .opacity(0.1)
                                            .opacity(story.id == stories.first?.id ? 1 : 0)
                                    )
                                    
                                    Divider()
                                        .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2))
                                }
                            } else {
                                Text("No saved stories yet")
                                    .font(.custom("Georgia", size: 16))
                                    .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                                    .padding()
                            }
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
        }
        .onAppear {
            store.dispatch(.loadAllStories)
        }
//        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    ReaderView()
}
