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
    
    var body: some View {
        ZStack {
            // Centered content (scroll icon and welcome text)
            if focusedField == nil && !showStoryForm {
                WelcomeView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            }
            
            // Bottom content (New Story button)
            VStack {
                Spacer()
                
                // Initial "New Story" button
                NewStoryButton(showStoryForm: $showStoryForm)
                    .padding(.bottom, 50)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            }
            .padding(.horizontal, 20)
        }
        .animation(.easeInOut(duration: 0.3), value: focusedField)
    }
}