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
    let isOpen: Bool
    let dragOffset: CGFloat
    let menuStatus: ReaderView.MenuStatus
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                SettingsRootView(
                    environment: store.environment.settingsEnvironment
                )
                
                SubscriptionMenuButton(action: {
                    store.dispatch(.setShowSubscriptionSheet(true))
                })
                Spacer()
            }
            .frame(width: 280)
            .background(PapyrusColor.background.color)
            .offset(x: calculateOffset())
            .animation(.easeInOut(duration: 0.3), value: isOpen)
        }
    }
    
    private func calculateOffset() -> CGFloat {
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
