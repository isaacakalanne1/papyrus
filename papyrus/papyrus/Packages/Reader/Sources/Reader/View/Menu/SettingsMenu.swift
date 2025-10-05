//
//  SettingsMenu.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import Settings
import PapyrusStyleKit

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
                    MenuSectionDivider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        MenuSubheader("Subscription")
                            .padding(.top, 20)
                        
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
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.8, green: 0.75, blue: 0.7), lineWidth: 1)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.3))
                                    )
                            )
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.bottom, 20)
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
