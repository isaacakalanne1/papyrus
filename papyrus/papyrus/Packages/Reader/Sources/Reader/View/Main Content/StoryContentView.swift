//
//  StoryContentView.swift
//  Reader
//
//  Created by Isaac Akalanne on 29/09/2025.
//

import SwiftUI
import TextGeneration
import Settings

/// Observes the enclosing UIScrollView's contentOffset via KVO and reports
/// changes to a callback. This replaces the SwiftUI preference-key approach,
/// which stops firing during scroll in iOS 17+ due to layout-pass decoupling.
private struct ScrollOffsetObserverView: UIViewRepresentable {
    let onOffsetChange: (CGFloat) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onOffsetChange: onOffsetChange) }

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isHidden = true
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard context.coordinator.observedScrollView == nil else { return }
        DispatchQueue.main.async {
            var candidate = uiView.superview
            while let current = candidate {
                if let scrollView = current as? UIScrollView {
                    context.coordinator.observe(scrollView)
                    return
                }
                candidate = current.superview
            }
        }
    }

    final class Coordinator: NSObject {
        weak var observedScrollView: UIScrollView?
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

    let startScrollOffsetTimer: () -> Void

    private func setupStoryView(with proxy: ScrollViewProxy, scrollGeometry: GeometryProxy) {
        store.dispatch(.setScrollViewHeight(scrollGeometry.size.height))
        startScrollOffsetTimer()

        if story.scrollOffset > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let actualScrollHeight = scrollGeometry.size.height > 0 ? scrollGeometry.size.height : UIScreen.main.bounds.height
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
                                // KVO-based scroll offset observer — replaces the broken
                                // preference-key approach which stops firing in iOS 17+.
                                ScrollOffsetObserverView { offset in
                                    store.dispatch(.setCurrentScrollOffset(offset))
                                }
                                .frame(height: 0)
                                .id("topAnchor")
                                
                                // Content
                                Text(story.chapters[story.chapterIndex].content)
                                    .font(.custom("Georgia", size: store.state.settingsState.selectedTextSize.fontSize))
                                    .lineSpacing(8)
                                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                                    .padding(.horizontal, 32)
                                    .padding(.top, 40)
                                    .padding(.bottom, store.state.isLoading ? 0 : 40)
                                    .id("content")
                                
                                if let failedAction = store.state.failedGenerationAction,
                                   story.chapterIndex == story.chapters.count - 1 {
                                    GenerationErrorView(
                                        onRetry: {
                                            store.dispatch(.retryGeneration(failedAction))
                                        },
                                        onDismiss: {
                                            store.dispatch(.dismissGenerationError)
                                        }
                                    )
                                    .padding(.bottom, 30)
                                } else if store.state.isLoading && story.chapterIndex == story.chapters.count - 1 {
                                    ChapterLoadingIndicator()
                                } else {
                                    // Next Chapter or Create Sequel Button
                                    Group {
                                        if story.chapterIndex == story.maxNumberOfChapters - 1 {
                                            PrimaryButton(
                                                type: .createSequel,
                                                isDisabled: store.state.isLoading,
                                                isLoading: store.state.isLoading
                                            ) {
                                                store.dispatch(.setIsSequelMode(true))
                                                store.dispatch(.updateMainCharacter(story.mainCharacter))
                                                store.dispatch(.updateSetting(""))
                                                store.dispatch(.setShowStoryForm(true))
                                                store.dispatch(.setFocusedField(.settingDetails))
                                            }
                                            .disabled(store.state.isLoading)
                                        } else {
                                            PrimaryButton(
                                                type: .nextChapter,
                                                isDisabled: store.state.isLoading,
                                                isLoading: store.state.isLoading
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
                        .onChange(of: story.id, { oldValue, newValue in
                            setupStoryView(with: proxy, scrollGeometry: scrollGeometry)
                        })
                        .onAppear {
                            setupStoryView(with: proxy, scrollGeometry: scrollGeometry)

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
