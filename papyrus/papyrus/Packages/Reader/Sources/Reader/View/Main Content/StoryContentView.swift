//
//  StoryContentView.swift
//  Reader
//
//  Created by Isaac Akalanne on 29/09/2025.
//

import PapyrusStyleKit
import Settings
import SwiftUI
import TextGeneration

/// Observes the enclosing UIScrollView's contentOffset via KVO and restores
/// a saved offset when the story changes. Uses UIKit directly because:
/// - SwiftUI's onPreferenceChange stops firing during scroll in iOS 17+
/// - SwiftUI's scrollTo anchor API uses a different coordinate system than
///   UIScrollView.contentOffset, causing safe-area mismatches on restoration
private struct ScrollOffsetObserverView: UIViewRepresentable {
    let onOffsetChange: (CGFloat) -> Void
    let restoreOffset: CGFloat
    let storyId: UUID

    func makeCoordinator() -> Coordinator { Coordinator(onOffsetChange: onOffsetChange) }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        let coordinator = context.coordinator

        if coordinator.observedScrollView == nil {
            DispatchQueue.main.async {
                var candidate = uiView.superview
                while let current = candidate {
                    if let scrollView = current as? UIScrollView {
                        coordinator.observe(scrollView)
                        break
                    }
                    candidate = current.superview
                }
            }
        }

        if coordinator.restoredStoryId != storyId, restoreOffset > 0 {
            coordinator.restoredStoryId = storyId
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                coordinator.observedScrollView?.setContentOffset(
                    CGPoint(x: 0, y: restoreOffset), animated: false
                )
            }
        }
    }

    final class Coordinator: NSObject {
        weak var observedScrollView: UIScrollView?
        var restoredStoryId: UUID?
        let onOffsetChange: (CGFloat) -> Void

        init(onOffsetChange: @escaping (CGFloat) -> Void) {
            self.onOffsetChange = onOffsetChange
        }

        func observe(_ scrollView: UIScrollView) {
            observedScrollView = scrollView
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        }

        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
            guard keyPath == "contentOffset",
                  let point = change?[.newKey] as? CGPoint else { return }
            onOffsetChange(point.y)
        }

        deinit { observedScrollView?.removeObserver(self, forKeyPath: "contentOffset") }
    }
}

struct StoryContentView: View {
    let story: Story
    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme

    let startScrollOffsetTimer: () -> Void

    private func setupStoryView(scrollGeometry: GeometryProxy) {
        store.dispatch(.setScrollViewHeight(scrollGeometry.size.height))
        startScrollOffsetTimer()
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                GeometryReader { scrollGeometry in
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 0) {
                                // KVO-based scroll offset observer and restorer.
                                // Replaces SwiftUI's preference-key (broken in iOS 17+)
                                // and proxy.scrollTo (mismatches UIKit's coordinate system).
                                ScrollOffsetObserverView(
                                    onOffsetChange: { offset in
                                        store.dispatch(.setCurrentScrollOffset(offset))
                                    },
                                    restoreOffset: story.scrollOffset,
                                    storyId: story.id
                                )
                                .frame(height: 0)
                                .id("topAnchor")

                                // Content
                                Text(story.chapters[story.chapterIndex].content)
                                    .font(.custom(store.state.settingsState.selectedFontName, size: store.state.settingsState.selectedTextSize.fontSize))
                                    .lineSpacing(8)
                                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                                    .padding(.horizontal, 32)
                                    .padding(.top, 40)
                                    .padding(.bottom, store.state.isLoading ? 0 : 40)
                                    .id("content")

                                if let failedAction = store.state.failedGenerationAction,
                                   story.chapterIndex == story.chapters.count - 1 {
                                    GenerationErrorView(
                                        fontName: store.state.settingsState.selectedFontName,
                                        onRetry: {
                                            store.dispatch(.retryGeneration(failedAction))
                                        },
                                        onDismiss: {
                                            store.dispatch(.dismissGenerationError)
                                        }
                                    )
                                    .padding(.bottom, 30)
                                } else if store.state.isLoading && story.chapterIndex == story.chapters.count - 1 {
                                    ChapterLoadingIndicator(fontName: store.state.settingsState.selectedFontName)
                                } else {
                                    // Next Chapter or Create Sequel Button
                                    Group {
                                        if story.chapterIndex == story.maxNumberOfChapters - 1 {
                                            PrimaryButton(
                                                type: .createSequel,
                                                isLoading: store.state.isLoading,
                                                fontName: store.state.settingsState.selectedFontName
                                            ) {
                                                store.dispatch(.setIsSequelMode(true))
                                                store.dispatch(.updateMainCharacter(story.mainCharacter))
                                                store.dispatch(.updateSetting(""))
                                                store.dispatch(.setShowStoryForm(true))
                                                store.dispatch(.setFocusedField(.settingDetails))
                                            }
                                        } else {
                                            PrimaryButton(
                                                type: .nextChapter,
                                                isLoading: store.state.isLoading,
                                                fontName: store.state.settingsState.selectedFontName
                                            ) {
                                                let nextIndex = story.chapterIndex + 1
                                                if story.chapters.count > nextIndex {
                                                    store.dispatch(.updateChapterIndex(story, nextIndex))
                                                } else {
                                                    store.dispatch(.createChapter(story))
                                                }
                                            }
                                            .disabled(store.state.isLoading)
                                        }
                                    }
                                    .padding(.bottom, 30)
                                }
                            }
                        }
                        .onChange(of: story.chapterIndex) { oldValue, newValue in
                            if oldValue != newValue {
                                proxy.scrollTo("content", anchor: .top)
                                store.dispatch(.setCurrentScrollOffset(0))

                                // Autogenerate next chapter if subscribed
                                if store.state.settingsState.isSubscribed && newValue >= story.chapters.count - 1 && newValue < story.maxNumberOfChapters - 1 && !store.state.isLoading {
                                    store.dispatch(.createChapter(story))
                                }
                            }
                        }
                        .onChange(of: story.id, { _, _ in
                            setupStoryView(scrollGeometry: scrollGeometry)
                        })
                        .onAppear {
                            setupStoryView(scrollGeometry: scrollGeometry)

                            // Autogenerate next chapter if subscribed and at the end
                            if store.state.settingsState.isSubscribed && story.chapterIndex >= story.chapters.count - 1 && story.chapterIndex < story.maxNumberOfChapters - 1 && !store.state.isLoading {
                                store.dispatch(.createChapter(story))
                            }
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
