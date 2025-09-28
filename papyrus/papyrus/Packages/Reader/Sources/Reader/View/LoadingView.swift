//
//  LoadingView.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var quillRotation: Double = 0
    @State private var inkDropScale: CGFloat = 0.8
    @State private var textOpacity: Double = 0.5
    
    var body: some View {
        VStack(spacing: 40) {
            // Animated quill pen writing
            ZStack {
                // Parchment circle background
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.94, green: 0.90, blue: 0.82),
                                Color(red: 0.92, green: 0.88, blue: 0.79)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                
                // Quill pen icon
                Image(systemName: "pencil.tip")
                    .font(.system(size: 48))
                    .foregroundColor(Color(red: 0.35, green: 0.30, blue: 0.25))
                    .rotationEffect(.degrees(quillRotation))
                    .offset(x: -5, y: -5)
                
                // Ink drops
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color(red: 0.2, green: 0.15, blue: 0.1).opacity(0.6))
                        .frame(width: 6, height: 6)
                        .scaleEffect(inkDropScale)
                        .offset(
                            x: CGFloat(index - 1) * 15,
                            y: 25
                        )
                        .animation(
                            Animation.easeInOut(duration: 1.2)
                                .repeatForever()
                                .delay(Double(index) * 0.3),
                            value: inkDropScale
                        )
                }
            }
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                ) {
                    quillRotation = -15
                }
                
                withAnimation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true)
                ) {
                    inkDropScale = 1.2
                }
            }
            
            // Loading text
            VStack(spacing: 8) {
                Text("Crafting your tale...")
                    .font(.custom("Georgia", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                    .opacity(textOpacity)
                
                Text("Every great story begins with a single word")
                    .font(.custom("Georgia", size: 14))
                    .italic()
                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                    .opacity(textOpacity * 0.8)
            }
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                ) {
                    textOpacity = 1.0
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.95),
                    Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.95)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    LoadingView()
}