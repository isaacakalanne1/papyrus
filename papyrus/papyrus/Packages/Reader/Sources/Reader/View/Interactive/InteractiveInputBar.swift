//
//  InteractiveInputBar.swift
//  Reader
//

import PapyrusStyleKit
import SwiftUI
import TextGeneration

struct InteractiveInputBar: View {
    let story: Story
    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme
    @State private var isSettingsPresented = false

    // 1. Add a FocusState to track when the text field is active
    @FocusState private var isInputFocused: Bool

    private var isDisabled: Bool {
        store.state.isLoading
    }

    private var canUndo: Bool {
        story.chapters.count > 1
    }

    private var canRedo: Bool {
        !store.state.undoneChapters.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Button {
                    store.dispatch(.undoInteractiveChapter)
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(
                            PapyrusColor.textSecondary.color(in: colorScheme)
                                .opacity(canUndo ? 1.0 : 0.3)
                        )
                }
                .disabled(!canUndo || isDisabled)

                Button {
                    store.dispatch(.redoInteractiveChapter)
                } label: {
                    Image(systemName: "arrow.uturn.forward")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(
                            PapyrusColor.textSecondary.color(in: colorScheme)
                                .opacity(canRedo ? 1.0 : 0.3)
                        )
                }
                .disabled(!canRedo || isDisabled)

                Button {
                    isSettingsPresented = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                }
                .disabled(isDisabled)
                .sheet(isPresented: $isSettingsPresented) {
                    InteractiveSettingsSheet(
                        isPresented: $isSettingsPresented,
                        currentSentenceCount: store.state.settingsState.sentenceCount
                    )
                    .environmentObject(store)
                }
            }

            HStack(spacing: 8) {
                TextField(
                    text: Binding(
                        get: { store.state.interactiveInputText },
                        set: { store.dispatch(.setInteractiveInputText($0)) }
                    ),
                    prompt: Text("Write what happens next")
                        .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                ) { EmptyView() }
                    .font(.custom(store.state.settingsState.selectedFontName, size: 15))
                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                    .disabled(isDisabled)
                    // 2. Bind the FocusState to the TextField
                    .focused($isInputFocused)
                    .onSubmit {
                        submitAction()
                    }

                Button(action: submitAction) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(
                            isDisabled
                                ? AnyShapeStyle(PapyrusColor.iconSecondary.color(in: colorScheme))
                                : AnyShapeStyle(
                                    LinearGradient(
                                        colors: [
                                            PapyrusColor.buttonGradientTop.color(in: colorScheme),
                                            PapyrusColor.buttonGradientBottom.color(in: colorScheme),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                }
                .disabled(isDisabled)
            }
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
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            PapyrusColor.background.color(in: colorScheme)
                .ignoresSafeArea(edges: .bottom)
        )
        .opacity(isDisabled ? 0.6 : 1.0)
        // 3. Add the toolbar for the keyboard
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputFocused = false
                }
            }
        }
    }

    private func submitAction() {
        let text = store.state.interactiveInputText.trimmingCharacters(in: .whitespacesAndNewlines)
        let action: ChapterAction? = text.isEmpty ? nil : .next(text)
        store.dispatch(.submitInteractiveAction(story, action))

        // Optional: dismiss the keyboard when submitting
        isInputFocused = false
    }
}
