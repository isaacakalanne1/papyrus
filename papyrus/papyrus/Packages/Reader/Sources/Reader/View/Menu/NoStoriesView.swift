//
//  NoStoriesView.swift
//  Reader
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI
import PapyrusStyleKit

struct NoStoriesView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No saved stories yet")
                .font(.custom("Georgia", size: 16))
                .foregroundColor(PapyrusColor.iconPrimary.color)
            Spacer()
        }
        .padding()
    }
}