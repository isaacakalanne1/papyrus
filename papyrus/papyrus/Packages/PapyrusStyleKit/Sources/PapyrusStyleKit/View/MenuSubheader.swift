//
//  MenuSubheader.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public struct MenuSubheader: View {
    let title: String
    
    public init(_ title: String) {
        self.title = title
    }
    
    public var body: some View {
        HStack {
            Text(title)
                .font(.custom("Georgia", size: 18))
                .foregroundColor(Color(red: 0.45, green: 0.4, blue: 0.35))
                .tracking(0.5)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    VStack(spacing: 20) {
        MenuMainHeader("Settings")
        MenuSubheader("Text Size")
        MenuSectionDivider()
        MenuSubheader("Subscription")
    }
    .frame(width: 320)
    .background(Color(red: 0.98, green: 0.95, blue: 0.89))
}
