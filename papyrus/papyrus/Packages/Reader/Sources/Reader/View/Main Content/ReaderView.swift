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
    @FocusState private var focusedField: ReaderField?
    @State private var scrollOffsetTimer: Timer?
    
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
                if store.state.isLoading && !store.state.contentState.hasStory {
                    LoadingView(
                        loadingStep: store.state.loadingStep,
                        hasExistingStory: store.state.story != nil
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                ContentStateView(
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
                    isEnabled: store.state.contentState.hasStory
                )
                
                UnifiedNavigationBar(
                    isMenuOpen: Binding(
                        get: { store.state.menuStatus == .storyOpen },
                        set: { newValue in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                store.dispatch(.setMenuStatus(newValue ? .storyOpen : .closed))
                            }
                        }
                    ),
                    isSettingsOpen: Binding(
                        get: { store.state.menuStatus == .settingsOpen },
                        set: { newValue in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                store.dispatch(.setMenuStatus(newValue ? .settingsOpen : .closed))
                            }
                        }
                    )
                )
            }
            .environment(\.readerFocusedField, $focusedField)
            
            // Modal overlay for both menu and settings
            ModalOverlay(
                isPresented: store.state.menuStatus != .closed,
                opacity: calculateOverlayOpacity(),
                onDismiss: {
                    store.dispatch(.setMenuStatus(.closed))
                }
            )
            .menuGestures(
                isForClosing: true,
                isEnabled: store.state.contentState.hasStory
            )
            
            // Side menu
            StoryMenu()
            
            // Settings menu (slides from right)
            SettingsMenu()
        }
        .sheet(isPresented: showStoryForm) {
            NewStoryForm()
                .environmentObject(store)
        }
        .sheet(isPresented: showSubscriptionSheet) {
            SubscriptionRootView(environment: store.environment.subscriptionEnvironment)
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            store.dispatch(.loadAllStories)
            store.dispatch(.loadSubscriptions)
        }
        .onChange(of: store.state.focusedField) { oldValue, newValue in
            focusedField = newValue
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if store.state.focusedField != newValue {
                store.dispatch(.setFocusedField(newValue))
            }
        }
    }
    
    private func startScrollOffsetTimer() {
        scrollOffsetTimer?.invalidate()
        scrollOffsetTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            DispatchQueue.main.async {
                if let story = store.state.story,
                   abs(store.state.currentScrollOffset - story.scrollOffset) > 1 {
                    store.dispatch(.updateScrollOffset(store.state.currentScrollOffset))
                }
            }
        }
    }
    
    private func calculateOverlayOpacity() -> Double {
        var opacity: Double = 0
        let dragOffset = store.state.dragOffset
        let menuStatus = store.state.menuStatus
        
        switch menuStatus {
        case .storyOpen:
            // When menu is open
            if dragOffset < 0 {
                // Closing menu (dragging left)
                opacity = 0.3 * (1 + dragOffset / 280.0)
            } else {
                opacity = 0.3
            }
            
        case .settingsOpen:
            // When settings is open
            if dragOffset > 0 {
                // Closing settings (dragging right)
                opacity = 0.3 * (1 - dragOffset / 280.0)
            } else {
                opacity = 0.3
            }
            
        case .closed:
            // When both are closed, calculate based on drag direction
            if dragOffset > 0 {
                // Opening menu (dragging right)
                opacity = Double(dragOffset / 280.0) * 0.3
            } else if dragOffset < 0 {
                // Opening settings (dragging left)
                opacity = Double(abs(dragOffset) / 280.0) * 0.3
            }
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
