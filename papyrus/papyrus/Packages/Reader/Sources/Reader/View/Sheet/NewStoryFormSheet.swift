//
//  NewStoryFormSheet.swift
//  Reader
//
//  Created by Isaac Akalanne on 02/10/2025.
//

import SwiftUI
import PapyrusStyleKit

struct NewStoryFormSheet: View {
    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var isSequelMode: Bool
    
    
    var body: some View {
        NewStoryForm(
            focusedField: $focusedField,
            isSequelMode: $isSequelMode
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            PapyrusColor.background.color,
                            PapyrusColor.backgroundSecondary.color
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .ignoresSafeArea()
    }
}
