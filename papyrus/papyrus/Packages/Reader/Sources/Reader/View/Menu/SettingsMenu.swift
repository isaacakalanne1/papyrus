//
//  SettingsMenu.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import Settings
import PapyrusStyleKit
import Subscription

struct SettingsMenu: View {
    @EnvironmentObject var store: ReaderStore
    @Environment(\.papyrusColorScheme) private var colorScheme

    var body: some View {
        HStack {
            Spacer()
            ScrollView {
                VStack {
                    SettingsRootView(
                        environment: store.environment.settingsEnvironment
                    )

                    SubscriptionMenuButton(fontName: store.state.settingsState.selectedFontName, action: {
                        store.dispatch(.setShowSubscriptionSheet(true))
                    })
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .frame(width: 280)
            .background(PapyrusColor.background.color(in: colorScheme))
            .offset(x: calculateOffset())
            .animation(.easeInOut(duration: 0.3), value: store.state.menuStatus == .settingsOpen)
        }
    }

    private func calculateOffset() -> CGFloat {
        let dragOffset = store.state.dragOffset
        let menuStatus = store.state.menuStatus

        switch menuStatus {
        case .settingsOpen:
            // Settings is open, allow closing gesture
            return max(0, dragOffset)
        case .storyOpen:
            // Story menu is open, keep settings offscreen
            return 280
        case .closed:
            // Both closed, only respond to negative drag (opening gesture)
            return 280 + min(0, dragOffset)
        }
    }
}
