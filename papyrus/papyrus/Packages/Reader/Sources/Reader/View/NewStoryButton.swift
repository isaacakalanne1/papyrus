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
        Button(action: {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showStoryForm = true
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20))
                Text("New Story")
                    .font(.custom("Georgia", size: 20))
                    .fontWeight(.medium)
            }
            .foregroundColor(Color(red: 0.98, green: 0.95, blue: 0.89))
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.45, green: 0.40, blue: 0.35),
                                Color(red: 0.35, green: 0.30, blue: 0.25)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 3)
            )
        }
    }
}
