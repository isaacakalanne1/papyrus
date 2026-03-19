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
    let fontName: String

    @Environment(\.papyrusColorScheme) private var colorScheme

    public init(_ title: String, showDivider: Bool = true, fontName: String = "Georgia") {
        self.title = title
        self.showDivider = showDivider
        self.fontName = fontName
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.custom(fontName, size: 24))
                .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

            if showDivider {
                Divider()
                    .background(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.5))
            }
        }
        .padding()
        .padding(.top, 20)
    }
}
