//
//  ReaderView.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI
import UIKit
import Settings
import Subscription

struct ReaderView: View {
    @EnvironmentObject var store: ReaderStore
    @State private var isMenuOpen: Bool = false
    @State private var isSettingsOpen: Bool = false
    @State private var settingsDragOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @State private var mainCharacter: String = ""
    @State private var settingDetails: String = ""
    @FocusState private var focusedField: Field?
    @State private var keyboardHeight: CGFloat = 0
    @State private var isSequelMode: Bool = false
    @State private var currentScrollOffset: CGFloat = 0
    @State private var scrollOffsetTimer: Timer?
    @State private var scrollViewHeight: CGFloat = 0
    @State private var isSubscriptionSheetOpen: Bool = false
    
    enum Field {
        case mainCharacter
        case settingDetails
    }
    
    init() {
        
    }
    
    public var body: some View {
        let showStoryForm: Binding<Bool> = .init {
            store.state.showStoryForm
        } set: { newValue in
            store.dispatch(.setShowStoryForm(newValue))
        }
        ZStack(alignment: .leading) {
            // Main content
            VStack(spacing: 0) {
                
                // Loading bar (appears below top bar when loading)
                if store.state.isLoading {
                    LoadingView(loadingStep: store.state.loadingStep, hasExistingStory: store.state.story != nil)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                ZStack {
                    if let story = store.state.story,
                       !story.chapters.isEmpty,
                       story.chapterIndex < story.chapters.count {
                        StoryContentView(
                            story: story,
                            focusedField: $focusedField,
                            isSequelMode: $isSequelMode,
                            currentScrollOffset: $currentScrollOffset,
                            scrollViewHeight: $scrollViewHeight,
                            startScrollOffsetTimer: startScrollOffsetTimer
                        )
                    } else {
                        WelcomeStateView(
                            focusedField: $focusedField,
                            isSequelMode: $isSequelMode
                        )
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
                
                UnifiedNavigationBar(
                    isMenuOpen: $isMenuOpen,
                    isSettingsOpen: $isSettingsOpen
                )
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Handle left edge swipe for menu
                        if value.startLocation.x < 20 && value.translation.width > 0 {
                            dragOffset = min(value.translation.width, 280)
                        }
                        // Handle right edge swipe for settings
                        else if value.startLocation.x > UIScreen.main.bounds.width - 20 && value.translation.width < 0 {
                            settingsDragOffset = max(value.translation.width, -320)
                        }
                    }
                    .onEnded { value in
                        // Open menu if dragged enough from left
                        if dragOffset > 100 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isMenuOpen = true
                            }
                        }
                        // Open settings if dragged enough from right
                        else if settingsDragOffset < -100 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isSettingsOpen = true
                            }
                        }
                        dragOffset = 0
                        settingsDragOffset = 0
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
            
            // Settings menu overlay
            if isSettingsOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isSettingsOpen = false
                        }
                    }
            }
            
            // Settings menu (slides from right)
            HStack {
                Spacer()
                VStack {
                    SettingsRootView(
                        environment: store.environment.settingsEnvironment
                    )
                    
                    VStack(spacing: 0) {
                        Divider()
                            .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3))
                            .padding(.horizontal)
                        
                        Button(action: {
                            isSubscriptionSheetOpen = true
                        }) {
                            HStack {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.8, green: 0.65, blue: 0.4))
                                
                                Text("Premium")
                                    .font(.custom("Georgia", size: 18))
                                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.98, green: 0.95, blue: 0.89))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Spacer()
                }
                .frame(width: 320)
                .background(Color(red: 0.98, green: 0.95, blue: 0.89))
                .offset(x: isSettingsOpen ? 0 : 320 + settingsDragOffset)
                .animation(.easeInOut(duration: 0.3), value: isSettingsOpen)
            }
            
            // No longer need overlay here since we're using sheet
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
        .sheet(isPresented: $isSubscriptionSheetOpen) {
            SubscriptionRootView(environment: store.environment.subscriptionEnvironment)
                .presentationDragIndicator(.visible)
        }
        .onChange(of: store.state.isLoading) { _, isLoading in
            if isLoading {
                store.dispatch(.setShowStoryForm(false))
                isSequelMode = false
                focusedField = nil
            }
        }
        .onAppear {
            store.dispatch(.loadAllStories)
            store.dispatch(.loadSubscriptions)
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
