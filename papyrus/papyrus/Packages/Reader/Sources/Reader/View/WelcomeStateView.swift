//
//  WelcomeStateView.swift
//  Reader
//
//  Created by Isaac Akalanne on 29/09/2025.
//

import SwiftUI

struct WelcomeStateView: View {
    @FocusState.Binding var focusedField: ReaderView.Field?
    @Binding var showStoryForm: Bool
    @Binding var isSequelMode: Bool
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Tap background to dismiss form
            if showStoryForm {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showStoryForm = false
                            isSequelMode = false
                            focusedField = nil
                        }
                    }
            }
            
            // Centered content (scroll icon and welcome text)
            if focusedField == nil && !showStoryForm {
                WelcomeView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            }
            
            // Bottom content (input fields and button)
            VStack {
                Spacer()
                
                if !showStoryForm {
                    // Initial "New Story" button
                    NewStoryButton(showStoryForm: $showStoryForm)
                        .padding(.bottom, 50)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                } else {
                    // Story form
                    NewStoryForm(
                        focusedField: $focusedField,
                        showStoryForm: $showStoryForm,
                        isSequelMode: $isSequelMode
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                    .onTapGesture {
                        // Prevent dismissal when tapping on the form itself
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .animation(.easeInOut(duration: 0.3), value: focusedField)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showStoryForm)
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
    }
}