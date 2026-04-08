//
//  ReaderView.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import PapyrusStyleKit
import Subscription
import SwiftUI
import UIKit

struct ReaderView: View {
    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme
    @FocusState private var focusedField: ReaderField?
    @State private var scrollOffsetTimer: Timer?

    private var activeColorScheme: PapyrusColorScheme {
        store.state.settingsState.selectedColorSchemeName.scheme
    }

    private var activeBackgroundImage: Image? {
        guard let selectedId = store.state.settingsState.selectedBackgroundImageId,
              let entry = store.state.settingsState.backgroundImages.first(where: { $0.id == selectedId }),
              let uiImage = UIImage(data: entry.imageData) else { return nil }
        return Image(uiImage: uiImage)
    }

    init() {}

    var body: some View {
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
                // Generation error banner (shown when a pipeline step fails)
                if let failedAction = store.state.failedGenerationAction {
                    GenerationErrorView(
                        fontName: store.state.settingsState.selectedFontName,
                        onRetry: {
                            store.dispatch(.retryGeneration(failedAction))
                        },
                        onDismiss: {
                            store.dispatch(.dismissGenerationError)
                        }
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                ContentStateView(
                    startScrollOffsetTimer: startScrollOffsetTimer
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollBounceBehavior(.basedOnSize)
                .animation(.easeInOut(duration: 0.4), value: store.state.isLoading)
                .menuGestures(
                    isEnabled: !store.state.contentState.hasStory
                )

                UnifiedNavigationBar()
                    .ignoresSafeArea(.keyboard)
            }
            .environment(\.readerFocusedField, $focusedField)

            // Loading bar (overlaid above content so it appears over background images)
            if store.state.isLoading && !store.state.contentState.hasStory {
                VStack {
                    LoadingView(
                        loadingDisplayStep: store.state.loadingStep,
                        hasExistingStory: store.state.story != nil,
                        fontName: store.state.settingsState.selectedFontName
                    )
                    .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
                }
            }

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
                isEnabled: !store.state.contentState.hasStory
            )

            // Side menu
            StoryMenu()

            // Settings menu (slides from right)
            SettingsMenu()
        }
        .environment(\.papyrusColorScheme, activeColorScheme)
        .environment(\.papyrusBackgroundImage, (
            image: activeBackgroundImage,
            usage: store.state.settingsState.backgroundImageUsage
        ))
        .sheet(isPresented: showStoryForm) {
            NewStoryForm()
                .environmentObject(store)
        }
        .sheet(isPresented: showSubscriptionSheet) {
            SubscriptionRootView(environment: store.environment.subscriptionEnvironment, fontName: store.state.settingsState.selectedFontName)
                .environment(\.papyrusColorScheme, activeColorScheme)
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            store.dispatch(.loadAllStories)
            store.dispatch(.loadSubscriptions)
        }
        .onChange(of: store.state.focusedField) { _, newValue in
            focusedField = newValue
        }
        .onChange(of: focusedField) { _, newValue in
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
                   abs(store.state.currentScrollOffset - story.scrollOffset) > 1
                {
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

#Preview {
    ReaderView()
}
