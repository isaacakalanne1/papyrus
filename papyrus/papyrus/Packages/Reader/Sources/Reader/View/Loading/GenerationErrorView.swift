//
//  GenerationErrorView.swift
//  Reader
//

import SwiftUI
import PapyrusStyleKit

/// Displayed in place of the loading indicator when chapter generation fails.
/// Mirrors the visual language of `ChapterWritingLoadingView` and `LoadingView`:
/// same background treatment, Georgia serif type, and PapyrusColor tokens.
struct GenerationErrorView: View {
    let onRetry: () -> Void
    let onDismiss: () -> Void
    let fontName: String

    @Environment(\.papyrusColorScheme) private var colorScheme

    init(fontName: String = "Georgia", onRetry: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        self.fontName = fontName
        self.onRetry = onRetry
        self.onDismiss = onDismiss
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                // Error icon — uses PapyrusColor.error on a parchment circle,
                // matching the circle treatment in LoadingView.
                ZStack {
                    Circle()
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
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(PapyrusColor.error.color(in: colorScheme).opacity(0.4), lineWidth: 1)
                        )

                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(PapyrusColor.error.color(in: colorScheme))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("The chapter could not be written")
                        .font(.custom(fontName, size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

                    Text("Something interrupted the quill. Shall we try once more?")
                        .font(.custom(fontName, size: 13))
                        .italic()
                        .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 14)

            // Divider
            Rectangle()
                .fill(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.12))
                .frame(height: 0.5)
                .padding(.horizontal, 20)

            // Action row
            HStack(spacing: 0) {
                // Dismiss
                Button(action: onDismiss) {
                    Text("Dismiss")
                        .font(.custom(fontName, size: 14))
                        .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }

                // Vertical separator between buttons
                Rectangle()
                    .fill(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.12))
                    .frame(width: 0.5, height: 44)
                    .padding(.vertical, 8)

                // Try Again — the primary action
                Button(action: onRetry) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Try Again")
                            .font(.custom(fontName, size: 14))
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(PapyrusColor.borderPrimary.color(in: colorScheme))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(errorBackground)
    }

    private var errorBackground: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        PapyrusColor.background.color(in: colorScheme).opacity(0.97),
                        PapyrusColor.backgroundSecondary.color(in: colorScheme).opacity(0.97)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Rectangle()
                    .stroke(PapyrusColor.error.color(in: colorScheme).opacity(0.15), lineWidth: 0.5)
                    .blur(radius: 0.5)
            )
    }
}

#Preview {
    VStack(spacing: 0) {
        GenerationErrorView(onRetry: {}, onDismiss: {})

        Rectangle()
            .fill(PapyrusColor.background.color(in: .parchment))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
