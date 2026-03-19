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

    init(fontName: String = "Georgia") {
        self.fontName = fontName
    }

    var body: some View {
        VStack {
            Spacer()
            Text("No saved stories yet")
                .font(.custom(fontName, size: 16))
                .foregroundColor(PapyrusColor.iconPrimary.color)
            Spacer()
        }
        .padding()
    }
}