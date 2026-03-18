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
                                    PapyrusColor.background.color,
                                    PapyrusColor.backgroundSecondary.color
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            Circle()
                                .stroke(PapyrusColor.error.color.opacity(0.4), lineWidth: 1)
                        )

                    Image(systemName: "exclamationmark.quill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(PapyrusColor.error.color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("The chapter could not be written")
                        .font(.custom("Georgia", size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(PapyrusColor.textPrimary.color)

                    Text("Something interrupted the quill. Shall we try once more?")
                        .font(.custom("Georgia", size: 13))
                        .italic()
                        .foregroundColor(PapyrusColor.textSecondary.color)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 14)

            // Divider
            Rectangle()
                .fill(PapyrusColor.iconPrimary.color.opacity(0.12))
                .frame(height: 0.5)
                .padding(.horizontal, 20)

            // Action row
            HStack(spacing: 0) {
                // Dismiss
                Button(action: onDismiss) {
                    Text("Dismiss")
                        .font(.custom("Georgia", size: 14))
                        .foregroundColor(PapyrusColor.textSecondary.color)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }

                // Vertical separator between buttons
                Rectangle()
                    .fill(PapyrusColor.iconPrimary.color.opacity(0.12))
                    .frame(width: 0.5)
                    .padding(.vertical, 8)

                // Try Again — the primary action
                Button(action: onRetry) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 12, weight: .semibold))
                        Text("Try Again")
                            .font(.custom("Georgia", size: 14))
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(PapyrusColor.borderPrimary.color)
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
                        PapyrusColor.background.color.opacity(0.97),
                        PapyrusColor.backgroundSecondary.color.opacity(0.97)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Rectangle()
                    .stroke(PapyrusColor.error.color.opacity(0.15), lineWidth: 0.5)
                    .blur(radius: 0.5)
            )
    }
}

#Preview {
    VStack(spacing: 0) {
        GenerationErrorView(onRetry: {}, onDismiss: {})

        Rectangle()
            .fill(PapyrusColor.background.color)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
