//
//  DeleteConfirmationSheet.swift
//  Reader
//

import SwiftUI
import TextGeneration
import PapyrusStyleKit

/// A fully custom deletion confirmation dialog.
/// Presented as a floating parchment card, matching the visual language of
/// `StoryDetailsPopup`: same card dimensions, corner radius, shadow, gradient,
/// and Georgia serif typography.
struct DeleteConfirmationSheet: View {
    let story: Story
    let onDelete: () -> Void
    let onCancel: () -> Void
    let fontName: String

    @Environment(\.papyrusColorScheme) private var colorScheme

    init(story: Story, fontName: String = "Georgia", onDelete: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.story = story
        self.fontName = fontName
        self.onDelete = onDelete
        self.onCancel = onCancel
    }

    private var storyTitle: String {
        story.title.isEmpty ? "Untitled Story" : story.title
    }

    var body: some View {
        ZStack {
            // Scrim — tapping it acts as cancel, consistent with StoryDetailsPopup behaviour.
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture { onCancel() }

            VStack(spacing: 24) {
                // Header
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Delete Story")
                            .font(.custom(fontName, size: 20))
                            .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

                        Text("This cannot be undone")
                            .font(.custom(fontName, size: 13))
                            .italic()
                            .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                    }

                    Spacer()

                    MenuButton(type: .close) { onCancel() }
                }

                // Story name badge — so the user knows exactly what they are about to lose.
                HStack(spacing: 12) {
                    Image(systemName: "book.closed")
                        .font(.system(size: 16))
                        .foregroundColor(PapyrusColor.iconPrimary.color(in: colorScheme))

                    Text(storyTitle)
                        .font(.custom(fontName, size: 16))
                        .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(PapyrusColor.borderSecondary.color(in: colorScheme).opacity(0.5), lineWidth: 0.5)
                        )
                )

                // Body copy
                Text("Are you sure you want to permanently delete \'\(storyTitle)\'? All chapters will be lost.")
                    .font(.custom(fontName, size: 15))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                // Action buttons — destructive stacked above cancel.
                VStack(spacing: 10) {
                    // Delete — visually distinct: error-toned, filled
                    Button(action: onDelete) {
                        HStack(spacing: 10) {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                            Text("Delete Story")
                                .font(.custom(fontName, size: 17))
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            PapyrusColor.error.color(in: colorScheme),
                                            PapyrusColor.error.color(in: colorScheme).opacity(0.8)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                        )
                    }

                    // Cancel — subdued, no fill; mirrors the secondary visual weight
                    // used elsewhere in the app for non-primary actions.
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(.custom(fontName, size: 17))
                            .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(PapyrusColor.borderSecondary.color(in: colorScheme), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(24)
            .frame(width: 320)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PapyrusColor.background.color(in: colorScheme),
                                PapyrusColor.backgroundSecondary.color(in: colorScheme)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .onTapGesture { } // Prevent tap from propagating to the scrim behind
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.3).ignoresSafeArea()

        DeleteConfirmationSheet(
            story: Story(mainCharacter: "Elara", setting: "A rain-soaked city"),
            onDelete: {},
            onCancel: {}
        )
    }
}
