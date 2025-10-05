//
//  ReaderView.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI
import UIKit
import Subscription
import PapyrusStyleKit

struct ReaderView: View {
    @EnvironmentObject var store: ReaderStore
    @State private var isMenuOpen: Bool = false
    @State private var isSettingsOpen: Bool = false
    @State private var settingsDragOffset: CGFloat = 0
    @State private var dragOffset: CGFloat = 0
    @FocusState private var focusedField: Field?
    @State private var isSequelMode: Bool = false
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
        let showStoryForm: Binding<Bool> = .init {
            store.state.showStoryForm
        } set: { newValue in
            store.dispatch(.setShowStoryForm(newValue))
        }
        
        let showSubscriptionSheet: Binding<Bool> = .init {
            store.state.showSubscriptionSheet
        } set: { newValue in
            store.dispatch(.setShowSubscriptionSheet(newValue))
        }
        ZStack(alignment: .leading) {
            // Main content
            VStack(spacing: 0) {
                
                // Loading bar (appears below top bar when loading)
                if store.state.isLoading {
                    LoadingView(loadingStep: store.state.loadingStep, hasExistingStory: store.state.story != nil)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                ContentStateView(
                    focusedField: $focusedField,
                    isSequelMode: $isSequelMode,
                    currentScrollOffset: $currentScrollOffset,
                    scrollViewHeight: $scrollViewHeight,
                    startScrollOffsetTimer: startScrollOffsetTimer
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            
            // Modal overlay for both menu and settings
            ModalOverlay(isPresented: isMenuOpen || isSettingsOpen) {
                isMenuOpen = false
                isSettingsOpen = false
            }
            
            // Side menu
            StoryMenu(
                isMenuOpen: $isMenuOpen,
                dragOffset: dragOffset
            )
            
            // Settings menu (slides from right)
            SettingsMenu(
                isOpen: isSettingsOpen,
                dragOffset: settingsDragOffset
            )
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
        .sheet(isPresented: showSubscriptionSheet) {
            SubscriptionRootView(environment: store.environment.subscriptionEnvironment)
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            store.dispatch(.loadAllStories)
            store.dispatch(.loadSubscriptions)
        }
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
