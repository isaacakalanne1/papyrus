//
//  SettingsMenu.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import Settings

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
                
                VStack(spacing: 0) {
                    Divider()
                        .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.3))
                        .padding(.horizontal)
                    
                    Button(action: {
                        store.dispatch(.setShowSubscriptionSheet(true))
                    }) {
                        HStack {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 0.8, green: 0.65, blue: 0.4))
                            
                            Text("Premium")
                                .font(.custom("Georgia", size: 18))
                                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.98, green: 0.95, blue: 0.89))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
            .frame(width: 320)
            .background(Color(red: 0.98, green: 0.95, blue: 0.89))
            .offset(x: isOpen ? 0 : 320 + dragOffset)
            .animation(.easeInOut(duration: 0.3), value: isOpen)
        }
    }
}
