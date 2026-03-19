//
//  StoryDetailsPopup.swift
//  Reader
//
//  Created by Isaac Akalanne on 02/10/2025.
//

import SwiftUI
import TextGeneration
import PapyrusStyleKit

struct StoryDetailsPopup: View {
    @EnvironmentObject var store: ReaderStore
    let story: Story
    @Binding var isPresented: Bool
    let fontName: String
    @Environment(\.papyrusColorScheme) private var colorScheme

    init(story: Story, isPresented: Binding<Bool>, fontName: String = "Georgia") {
        self.story = story
        self._isPresented = isPresented
        self.fontName = fontName
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

                ScrollView {
                    Text(story.title.isEmpty ? "Untitled Story" : story.title)
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
