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
                .menuGestures(
                    isMenuOpen: $isMenuOpen,
                    isSettingsOpen: $isSettingsOpen,
                    dragOffset: $dragOffset,
                    settingsDragOffset: $settingsDragOffset
                )
                
                UnifiedNavigationBar(
                    isMenuOpen: $isMenuOpen,
                    isSettingsOpen: $isSettingsOpen
                )
            }
            
            // Modal overlay for both menu and settings
            ModalOverlay(
                isPresented: isMenuOpen || isSettingsOpen,
                opacity: calculateOverlayOpacity(),
                onDismiss: {
                    isMenuOpen = false
                    isSettingsOpen = false
                }
            )
            .menuGestures(
                isMenuOpen: $isMenuOpen,
                isSettingsOpen: $isSettingsOpen,
                dragOffset: $dragOffset,
                settingsDragOffset: $settingsDragOffset,
                isForClosing: true
            )
            
            // Side menu
            StoryMenu(
                isMenuOpen: $isMenuOpen,
                dragOffset: dragOffset
            )
            
            // Settings menu (slides from right)
            SettingsMenu(
                isOpen: isSettingsOpen,
                dragOffset: dragOffset
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
    
    private func calculateOverlayOpacity() -> Double {
        var opacity: Double = 0
        
        // Calculate opacity for menu
        if isMenuOpen {
            // When closing menu (dragging left)
            if dragOffset < 0 {
                opacity = 0.3 * (1 + dragOffset / 280.0)
            } else {
                opacity = 0.3
            }
        } else if dragOffset > 0 {
            // When opening menu (dragging right from left edge)
            opacity = Double(dragOffset / 280.0) * 0.3
        }
        
        // Calculate opacity for settings
        if isSettingsOpen {
            // When closing settings (dragging right)
            if dragOffset > 0 {
                opacity = 0.3 * (1 - dragOffset / 280.0)
            } else {
                opacity = 0.3
            }
        } else if dragOffset < 0 {
            // When opening settings (dragging left from right edge)
            opacity = Double(abs(dragOffset) / 280.0) * 0.3
        }
        
        return max(0, min(opacity, 0.3))
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
