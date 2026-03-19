//
//  MenuSubheader.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public struct MenuSubheader: View {
    let title: String
    let fontName: String

    @Environment(\.papyrusColorScheme) private var colorScheme

    public init(_ title: String, fontName: String = "Georgia") {
        self.title = title
        self.fontName = fontName
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(.custom(fontName, size: 18))
                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
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
    .background(PapyrusColor.background.color(in: .parchment))
}
