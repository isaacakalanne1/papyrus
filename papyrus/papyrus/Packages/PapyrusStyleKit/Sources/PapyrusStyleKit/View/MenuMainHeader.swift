//
//  MenuMainHeader.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public struct MenuMainHeader: View {
    let title: String
    let showDivider: Bool
    
    public init(_ title: String, showDivider: Bool = true) {
        self.title = title
        self.showDivider = showDivider
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom("Georgia", size: 24))
                .foregroundColor(PapyrusColor.textPrimary.color)
            
            if showDivider {
                Divider()
                    .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.5))
            }
        }
        .padding()
        .padding(.top, 20)
    }
}
