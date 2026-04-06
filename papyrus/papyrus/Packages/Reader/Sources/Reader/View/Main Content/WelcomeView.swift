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

    var body: some View {
        ZStack {
            // Bottom content (New Story button)
            VStack {
                Spacer()
                SDIcons.scroll.image
                    .frame(width: 64, height: 64)
                    .saturation(colorScheme == .parchment ? 1 : 0)
                    .colorMultiply(colorScheme == .parchment ? .white : PapyrusColor.iconPrimary.color(in: colorScheme))
                    .opacity(0.5)
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
            if backgroundImage.usage.contains(.home), let img = backgroundImage.image {
                img
                    .resizable()
                    .scaledToFill()
                    .clipped()
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [
                        PapyrusColor.background.color(in: colorScheme),
                        PapyrusColor.backgroundSecondary.color(in: colorScheme)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
    }
}
