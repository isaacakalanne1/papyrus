//
//  NewStoryButton.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import SwiftUI

struct NewStoryButton: View {
    @Binding var showStoryForm: Bool
    
    var body: some View {
        PrimaryButton(
            title: "New Story",
            icon: "plus.circle.fill"
        ) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showStoryForm = true
            }
        }
    }
}
