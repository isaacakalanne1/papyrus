//
//  ChapterWritingLoadingView.swift
//  Reader
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import SwiftUI
import PapyrusStyleKit

struct ChapterWritingLoadingView: View {
    @State private var pulseScale: CGFloat = 1.0
    @State private var dotCount: Int = 0
    @State private var showingQuote: Bool = false
    
    private let writingQuotes = [
        "Every chapter is a new beginning",
        "The story unfolds, one word at a time",
        "Creating worlds with every sentence",
        "Your characters await their next adventure",
        "Weaving narrative threads together"
    ]
    
    @State private var currentQuote: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Animated writing indicator
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    PapyrusColor.accent.color,
                                    Color(red: 0.7, green: 0.55, blue: 0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .scaleEffect(pulseScale)
                        .overlay(
                            Circle()
                                .stroke(Color(red: 0.5, green: 0.35, blue: 0.2).opacity(0.3), lineWidth: 1)
                        )
                    
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("Writing Chapter")
                            .font(.custom("Georgia", size: 18))
                            .fontWeight(.semibold)
                            .foregroundColor(PapyrusColor.textPrimary.color)
                        
                        ForEach(0..<3, id: \.self) { index in
                            Text(".")
                                .font(.custom("Georgia", size: 18))
                                .fontWeight(.semibold)
                                .foregroundColor(PapyrusColor.textPrimary.color)
                                .opacity(index < dotCount ? 1 : 0)
                        }
                    }
                    
                    if showingQuote {
                        Text(currentQuote)
                            .font(.custom("Georgia", size: 13))
                            .italic()
                            .foregroundColor(PapyrusColor.textSecondary.color)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            PapyrusColor.background.color.opacity(0.95),
                            PapyrusColor.backgroundSecondary.color.opacity(0.95)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Rectangle()
                        .stroke(PapyrusColor.iconPrimary.color.opacity(0.1), lineWidth: 0.5)
                        .blur(radius: 0.5)
                )
        )
        .onAppear {
            // Start pulse animation
            withAnimation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                pulseScale = 1.15
            }
            
            // Start dots animation
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
                Task { @MainActor in
                    withAnimation {
                        dotCount = (dotCount + 1) % 4
                    }
                }
            }
            
            // Show quote after a delay
            currentQuote = writingQuotes.randomElement() ?? writingQuotes[0]
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation {
                    showingQuote = true
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 0) {
        // Simulated unified navigation bar
        HStack {
            Image(systemName: "text.alignleft")
                .font(.system(size: 20))
                .foregroundColor(PapyrusColor.iconSecondary.color)
                .padding()
            Spacer()
            Text("Chapter 5 of 12")
                .font(.custom("Georgia", size: 14))
                .foregroundColor(PapyrusColor.textSecondary.color)
            Spacer()
            Image(systemName: "gearshape")
                .font(.system(size: 20))
                .foregroundColor(PapyrusColor.iconSecondary.color)
                .padding()
        }
        .background(PapyrusColor.background.color.opacity(0.95))
        
        // Chapter writing loading view
        ChapterWritingLoadingView()
        
        // Simulated content
        Rectangle()
            .fill(PapyrusColor.background.color)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
