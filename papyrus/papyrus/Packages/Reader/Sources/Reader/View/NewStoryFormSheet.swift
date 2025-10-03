//
//  NewStoryFormSheet.swift
//  Reader
//
//  Created by Isaac Akalanne on 02/10/2025.
//

import SwiftUI

struct NewStoryFormSheet: View {
    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var showStoryForm: Bool
    @Binding var isSequelMode: Bool
    @EnvironmentObject var store: ReaderStore
    
    var body: some View {
        VStack(spacing: 0) {
            NewStoryForm(
                focusedField: $focusedField,
                showStoryForm: $showStoryForm,
                isSequelMode: $isSequelMode
            )
        }
        .frame(width: 350)
        .frame(minHeight: 450, idealHeight: 500, maxHeight: 600)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.98, green: 0.95, blue: 0.89),
                            Color(red: 0.96, green: 0.92, blue: 0.84)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}