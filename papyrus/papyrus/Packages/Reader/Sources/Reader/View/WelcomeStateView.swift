//
//  WelcomeStateView.swift
//  Reader
//
//  Created by Isaac Akalanne on 29/09/2025.
//

import SwiftUI

struct WelcomeStateView: View {
    @EnvironmentObject var store: ReaderStore

    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var isSequelMode: Bool
    
    var body: some View {
        ZStack {
            // Centered content (scroll icon and welcome text)
            
            
            // Bottom content (New Story button)
            VStack {
                Spacer()
                if focusedField == nil && !store.state.showStoryForm {
                    WelcomeView()
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                }
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
