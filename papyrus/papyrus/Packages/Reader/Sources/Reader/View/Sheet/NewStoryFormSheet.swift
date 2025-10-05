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
    @EnvironmentObject var store: ReaderStore
    var dismissAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Invisible background to catch taps
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if let dismissAction = dismissAction {
                        dismissAction()
                    } else {
                        store.dispatch(.setShowStoryForm(false))
                    }
                }
            
            NewStoryForm(
                focusedField: $focusedField,
                isSequelMode: $isSequelMode
            )
            .frame(width: 350, height: 500)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PapyrusColor.background.color,
                                Color(red: 0.96, green: 0.92, blue: 0.84)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .onTapGesture { } // Prevent tap from propagating to background
        }
    }
}
