//
//  SubscriptionMenuButton.swift
//  Subscription
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI
import PapyrusStyleKit

public struct SubscriptionMenuButton: View {
    let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            MenuSectionDivider()
            
            VStack(alignment: .leading, spacing: 12) {
                MenuSubheader("Subscription")
                    .padding(.top, 20)
                
                Button(action: action) {
                    HStack {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 18))
                            .foregroundColor(PapyrusColor.accent.color)
                        
                        Text("Premium")
                            .font(.custom("Georgia", size: 18))
                            .foregroundColor(PapyrusColor.textPrimary.color)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                            .foregroundColor(PapyrusColor.textSecondary.color)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(PapyrusColor.borderSecondary.color, lineWidth: 1)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(PapyrusColor.backgroundSecondary.color.opacity(0.3))
                            )
                    )
                    .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    SubscriptionMenuButton(action: {
        print("Premium button tapped")
    })
    .frame(width: 320)
}
