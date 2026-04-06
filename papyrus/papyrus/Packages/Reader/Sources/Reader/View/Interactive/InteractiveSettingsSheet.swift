//
//  InteractiveSettingsSheet.swift
//  Reader
//

import SwiftUI
import PapyrusStyleKit

struct InteractiveSettingsSheet: View {
    @EnvironmentObject var store: ReaderStore
    @Binding var isPresented: Bool
    @Environment(\.papyrusColorScheme) private var colorScheme

    @State private var draftSentenceCount: Int

    init(isPresented: Binding<Bool>, currentSentenceCount: Int) {
        _isPresented = isPresented
        _draftSentenceCount = State(initialValue: currentSentenceCount)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                header
                Divider()
                    .background(PapyrusColor.borderSecondary.color(in: colorScheme))
                sentenceCountSection
                Spacer()
                confirmButton
            }
            closeButton
        }
        .background(PapyrusColor.background.color(in: colorScheme))
    }

    // MARK: - Subviews

    private var header: some View {
        HStack {
            Text("Story Settings")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var sentenceCountSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Response Length")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

            Text(sentenceCountLabel)
                .font(.system(size: 13))
                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))

            Slider(
                value: Binding(
                    get: { Double(draftSentenceCount) },
                    set: { draftSentenceCount = Int($0.rounded()) }
                ),
                in: 1...10,
                step: 1
            )
            .accentColor(PapyrusColor.accent.color(in: colorScheme))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private var sentenceCountLabel: String {
        draftSentenceCount == 1 ? "1 sentence per response" : "\(draftSentenceCount) sentences per response"
    }

    private var confirmButton: some View {
        Button(action: confirm) {
            Text("Confirm")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(PapyrusColor.background.color(in: colorScheme))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    LinearGradient(
                        colors: [
                            PapyrusColor.buttonGradientTop.color(in: colorScheme),
                            PapyrusColor.buttonGradientBottom.color(in: colorScheme)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }

    private var closeButton: some View {
        MenuButton(type: .largeClose) {
            isPresented = false
        }
        .padding(24)
    }

    // MARK: - Actions

    private func confirm() {
        store.dispatch(.setSentenceCount(draftSentenceCount))
        isPresented = false
    }
}
