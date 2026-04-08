//
//  StoryDetailsPopup.swift
//  Reader
//
//  Created by Isaac Akalanne on 02/10/2025.
//

import PapyrusStyleKit
import SwiftUI
import TextGeneration

struct StoryDetailsPopup: View {
    @EnvironmentObject var store: ReaderStore
    let story: Story
    @Binding var isPresented: Bool
    let fontName: String
    @Environment(\.papyrusColorScheme) private var colorScheme
    @State private var editableTitle: String
    @FocusState private var isTitleFocused: Bool

    init(story: Story, isPresented: Binding<Bool>, fontName: String = "Georgia") {
        self.story = story
        _isPresented = isPresented
        self.fontName = fontName
        _editableTitle = State(initialValue: story.title)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Story Details")
                    .font(.custom(fontName, size: 20))
                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

                Spacer()

                MenuButton(type: .close) {
                    isPresented = false
                }
            }

            // Title section
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .font(.custom(fontName, size: 14))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))

                HStack(spacing: 8) {
                    TextField(
                        text: $editableTitle,
                        prompt: Text("Untitled Story")
                            .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                    ) { EmptyView() }
                        .font(.custom(fontName, size: 16))
                        .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                        .focused($isTitleFocused)
                        .onChange(of: editableTitle) { _, newTitle in
                            store.dispatch(.updateStoryTitle(story, newTitle))
                        }

                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                        .onTapGesture { isTitleFocused = true }
                }
                .padding(12)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.1))
                )
            }

            // Main character section
            VStack(alignment: .leading, spacing: 8) {
                Text("Main Character")
                    .font(.custom(fontName, size: 14))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))

                ScrollView {
                    Text(story.mainCharacter.isEmpty ? "Not specified" : story.mainCharacter)
                        .font(.custom(fontName, size: 16))
                        .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.1))
                )
                .scrollBounceBehavior(.basedOnSize)
            }

            // Perspective section
            VStack(alignment: .leading, spacing: 8) {
                Text("Perspective")
                    .font(.custom(fontName, size: 14))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))

                Text(story.perspective == .firstPerson ? "First Person" : "Third Person")
                    .font(.custom(fontName, size: 16))
                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.1))
                    )
            }

            // Setting details section with scrollview
            VStack(alignment: .leading, spacing: 8) {
                Text("Story Details")
                    .font(.custom(fontName, size: 14))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))

                ScrollView {
                    Text(story.setting.isEmpty ? "Not specified" : story.setting)
                        .font(.custom(fontName, size: 16))
                        .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
                .frame(height: 150)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.1))
                )
                .scrollBounceBehavior(.basedOnSize)
            }

            PrimaryButton(
                type: .reuseDetails,
                size: .medium,
                isLoading: false,
                fontName: fontName
            ) {
                store.dispatch(.reuseStoryDetails(story))
            }

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(PapyrusColor.background.color(in: colorScheme))
    }
}
