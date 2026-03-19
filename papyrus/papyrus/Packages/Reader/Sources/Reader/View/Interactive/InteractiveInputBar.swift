//
//  InteractiveInputBar.swift
//  Reader
//

import SwiftUI
import PapyrusStyleKit
import TextGeneration

struct InteractiveInputBar: View {
    let story: Story
    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme

    private var isDisabled: Bool {
        store.state.isLoading || story.chapters.filter { $0.action != nil }.count >= 10
    }

    private var selectedActionMode: InteractiveActionMode {
        store.state.selectedActionMode
    }

    var body: some View {
        VStack(spacing: 8) {
            // Mode toggles
            HStack(spacing: 8) {
                actionModeButton(mode: .do, label: "Do")
                actionModeButton(mode: .say, label: "Say")
                actionModeButton(mode: .event, label: "Event")
            }

            // Input row
            HStack(spacing: 8) {
                TextField(
                    placeholderText,
                    text: Binding(
                        get: { store.state.interactiveInputText },
                        set: { store.dispatch(.setInteractiveInputText($0)) }
                    )
                )
                .font(.custom(store.state.settingsState.selectedFontName, size: 15))
                .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                .disabled(isDisabled)
                .onSubmit {
                    submitAction()
                }

                Button(action: submitAction) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(
                            isDisabled || store.state.interactiveInputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                ? AnyShapeStyle(PapyrusColor.iconSecondary.color(in: colorScheme))
                                : AnyShapeStyle(
                                    LinearGradient(
                                        colors: [
                                            PapyrusColor.buttonGradientTop.color(in: colorScheme),
                                            PapyrusColor.buttonGradientBottom.color(in: colorScheme)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                }
                .disabled(isDisabled || store.state.interactiveInputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(PapyrusColor.backgroundSecondary.color(in: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(PapyrusColor.borderSecondary.color(in: colorScheme), lineWidth: 1)
                    )
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            PapyrusColor.background.color(in: colorScheme)
                .ignoresSafeArea(edges: .bottom)
        )
        .opacity(isDisabled ? 0.6 : 1.0)
    }

    @ViewBuilder
    private func actionModeButton(mode: InteractiveActionMode, label: String) -> some View {
        let isSelected = selectedActionMode == mode
        Button {
            store.dispatch(.setSelectedActionMode(mode))
        } label: {
            Text(label)
                .font(.custom(store.state.settingsState.selectedFontName, size: 13))
                .fontWeight(.medium)
                .foregroundColor(
                    isSelected
                        ? PapyrusColor.background.color(in: colorScheme)
                        : PapyrusColor.textSecondary.color(in: colorScheme)
                )
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(
                            isSelected
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: [
                                            PapyrusColor.buttonGradientTop.color(in: colorScheme),
                                            PapyrusColor.buttonGradientBottom.color(in: colorScheme)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                : AnyShapeStyle(PapyrusColor.backgroundSecondary.color(in: colorScheme))
                        )
                )
        }
        .disabled(isDisabled)
    }

    private var placeholderText: String {
        switch selectedActionMode {
        case .do: return "What do you do?"
        case .say: return "What do you say?"
        case .event: return "What happens?"
        }
    }

    private func submitAction() {
        let text = store.state.interactiveInputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let action: ChapterAction
        switch store.state.selectedActionMode {
        case .do:
            action = .do(text)
        case .say:
            action = .say(text)
        case .event:
            action = .event(text)
        }

        store.dispatch(.submitInteractiveAction(story, action))
    }
}
