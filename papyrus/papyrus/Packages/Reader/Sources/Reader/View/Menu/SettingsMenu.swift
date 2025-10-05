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
            .frame(width: 320)
            .background(PapyrusColor.background.color)
            .offset(x: isOpen ? 0 : 320 + dragOffset)
            .animation(.easeInOut(duration: 0.3), value: isOpen)
        }
    }
}
