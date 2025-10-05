//
//  WelcomeView.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import SDIconsKit
import PapyrusStyleKit

struct WelcomeView: View {
    @EnvironmentObject var store: ReaderStore
    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var isSequelMode: Bool
    
    var body: some View {
        ZStack {
            // Bottom content (New Story button)
            VStack {
                Spacer()
                SDIcons.scroll.image
                    .frame(width: 64, height: 64)
                    .foregroundColor(PapyrusColor.iconPrimary.color)
                    .opacity(0.5)
                Spacer()
                
                // Initial "New Story" button
                PrimaryButton(
                    type: .newStory,
                    isDisabled: store.state.isLoading
                ) {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        store.dispatch(.setShowStoryForm(true))
                    }
                }
                    .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
        }
        .animation(.easeInOut(duration: 0.3), value: focusedField)
    }
}
