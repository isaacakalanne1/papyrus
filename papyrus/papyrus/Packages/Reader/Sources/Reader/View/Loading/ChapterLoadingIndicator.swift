//
//  ChapterLoadingIndicator.swift
//  Reader
//
//  Created by Isaac Akalanne on 07/01/2026.
//

import SwiftUI
import PapyrusStyleKit

struct ChapterLoadingIndicator: View {
    @State private var pulseOpacity: Double = 0.4
    @State private var moveOffset: CGFloat = -5
    
    var body: some View {
        VStack(spacing: 16) {
            // Divider line with a central icon
            HStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PapyrusColor.iconPrimary.color.opacity(0),
                                PapyrusColor.iconPrimary.color.opacity(0.3)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
                
                Image(systemName: "pencil.and.outline")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(PapyrusColor.iconPrimary.color)
                    .opacity(pulseOpacity)
                    .offset(y: moveOffset)
                
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PapyrusColor.iconPrimary.color.opacity(0.3),
                                PapyrusColor.iconPrimary.color.opacity(0)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
            }
            .padding(.horizontal, 40)
            
            Text("The next chapter is being crafted...")
                .font(.custom("Georgia", size: 16))
                .italic()
                .foregroundColor(PapyrusColor.textSecondary.color)
                .multilineTextAlignment(.center)
                .opacity(pulseOpacity)
        }
        .padding(.vertical, 40)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
            ) {
                pulseOpacity = 0.8
                moveOffset = 5
            }
        }
    }
}

#Preview {
    ZStack {
        PapyrusColor.background.color.ignoresSafeArea()
        ChapterLoadingIndicator()
    }
}
