//
//  NoStoriesView.swift
//  Reader
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI
import PapyrusStyleKit

struct NoStoriesView: View {
    let fontName: String
    @Environment(\.papyrusColorScheme) private var colorScheme

    init(fontName: String = "Georgia") {
        self.fontName = fontName
    }

    var body: some View {
        VStack {
            Spacer()
            Text("No saved stories yet")
                .font(.custom(fontName, size: 16))
                .foregroundColor(PapyrusColor.iconPrimary.color(in: colorScheme))
            Spacer()
        }
        .padding()
    }
}
