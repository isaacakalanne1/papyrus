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
    @State private var menuStatus: MenuStatus = .closed
    @State private var dragOffset: CGFloat = 0
    @FocusState private var focusedField: Field?
    @State private var isSequelMode: Bool = false
    @State private var currentScrollOffset: CGFloat = 0
    @State private var scrollOffsetTimer: Timer?
    @State private var scrollViewHeight: CGFloat = 0
    
    enum MenuStatus {
        case closed
        case storyOpen
        case settingsOpen
    }
    
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
                    menuStatus: $menuStatus,
                    dragOffset: $dragOffset
                )
                
                UnifiedNavigationBar(
                    isMenuOpen: Binding(
                        get: { menuStatus == .storyOpen },
                        set: { newValue in
                            if newValue {
                                menuStatus = .storyOpen
                            } else {
                                menuStatus = .closed
                            }
                        }
                    ),
                    isSettingsOpen: Binding(
                        get: { menuStatus == .settingsOpen },
                        set: { newValue in
                            if newValue {
                                menuStatus = .settingsOpen
                            } else {
                                menuStatus = .closed
                            }
                        }
                    )
                )
            }
            
            // Modal overlay for both menu and settings
            ModalOverlay(
                isPresented: menuStatus != .closed,
                opacity: calculateOverlayOpacity(),
                onDismiss: {
                    menuStatus = .closed
                }
            )
            .menuGestures(
                menuStatus: $menuStatus,
                dragOffset: $dragOffset,
                isForClosing: true
            )
            
            // Side menu
            StoryMenu(
                isMenuOpen: Binding(
                    get: { menuStatus == .storyOpen },
                    set: { newValue in
                        if newValue {
                            menuStatus = .storyOpen
                        } else {
                            menuStatus = .closed
                        }
                    }
                ),
                dragOffset: dragOffset,
                menuStatus: menuStatus
            )
            
            // Settings menu (slides from right)
            SettingsMenu(
                isOpen: menuStatus == .settingsOpen,
                dragOffset: dragOffset,
                menuStatus: menuStatus
            )
        }
        .sheet(isPresented: showStoryForm) {
            NewStoryFormSheet(
                focusedField: $focusedField,
                isSequelMode: $isSequelMode
            )
            .environmentObject(store)
            .presentationBackground(.clear)
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
