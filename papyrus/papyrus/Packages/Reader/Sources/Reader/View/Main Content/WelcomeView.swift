//
//  WelcomeView.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import SDIconsKit
import PapyrusStyleKit

struct WelcomeView: View {
    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme
    @Environment(\.papyrusBackgroundImage) private var backgroundImage

    private var isShowingBackgroundImage: Bool {
        backgroundImage.usage.contains(.home) && backgroundImage.image != nil
    }

    var body: some View {
        ZStack {
            // Bottom content (New Story button)
            VStack {
                Spacer()

                if !isShowingBackgroundImage {
                    SDIcons.scroll.image
                        .frame(width: 64, height: 64)
                        .saturation(colorScheme == .parchment ? 1 : 0)
                        .colorMultiply(colorScheme == .parchment ? .white : PapyrusColor.iconPrimary.color(in: colorScheme))
                        .opacity(0.5)
                }

                Spacer()

                // Initial "New Story" button
                PrimaryButton(isLoading: store.state.isLoading, fontName: store.state.settingsState.selectedFontName) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        store.dispatch(.setShowStoryForm(true))
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            if let img = backgroundImage.image, backgroundImage.usage.contains(.home) {
                ZStack(alignment: .bottom) {
                    img
                        .resizable()
                        .scaledToFill()
                        .clipped()

                    LinearGradient(
                        colors: [.clear, .black.opacity(0.55)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                }
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        PapyrusColor.background.color(in: colorScheme),
                        PapyrusColor.backgroundSecondary.color(in: colorScheme)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
        }
    }
}
