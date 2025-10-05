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
                            .foregroundColor(Color(red: 0.8, green: 0.65, blue: 0.4))
                        
                        Text("Premium")
                            .font(.custom("Georgia", size: 18))
                            .foregroundColor(PapyrusColor.textPrimary.color)
                        
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
    }
}

#Preview {
    SubscriptionMenuButton(action: {
        print("Premium button tapped")
    })
    .frame(width: 320)
}
