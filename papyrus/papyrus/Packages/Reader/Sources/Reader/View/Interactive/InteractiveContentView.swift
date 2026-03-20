//
//  InteractiveContentView.swift
//  Reader
//

import SwiftUI
import PapyrusStyleKit
import TextGeneration

struct InteractiveContentView: View {
    let story: Story
    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            ForEach(story.chapters.indices, id: \.self) { index in
                                paragraphView(for: story.chapters[index])
                            }

                            if store.state.isLoading {
                                ChapterLoadingIndicator(
                                    fontName: store.state.settingsState.selectedFontName
                                )
                            }

                            Color.clear
                                .frame(height: 1)
                                .id("bottom")
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                        .id("content")
                    }
                    .onAppear {
                        proxy.scrollTo("bottom", anchor: .top)
                    }
                    .onChange(of: story.chapters.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo("bottom", anchor: .top)
                        }
                    }
                }

                // Close button
                MenuButton(type: .close) {
                    store.dispatch(.setStory(nil))
                }
                .padding(16)
            }

            InteractiveInputBar(story: story)
        }
    }

    @ViewBuilder
    private func paragraphView(for chapter: Chapter) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let action = chapter.action {
                InteractiveActionView(
                    action: action,
                    fontName: store.state.settingsState.selectedFontName
                )
            }

            if !chapter.content.isEmpty {
                Text(chapter.content)
                    .font(.custom(store.state.settingsState.selectedFontName, size: store.state.settingsState.selectedTextSize.fontSize))
                    .lineSpacing(8)
                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                    .opacity(1.0)
            }
        }
        .padding(.bottom, 24)
    }


}

// MARK: - InteractiveActionView

private struct InteractiveActionView: View {
    let action: ChapterAction
    let fontName: String
    @Environment(\.papyrusColorScheme) private var colorScheme

    var body: some View {
        switch action {
        case .next(let text):
            Text(text)
                .font(.custom(fontName, size: 14))
                .italic()
                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
        }
    }
}
