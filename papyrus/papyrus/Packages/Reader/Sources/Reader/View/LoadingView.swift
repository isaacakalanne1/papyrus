//
//  LoadingView.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import SwiftUI

struct LoadingView: View {
    let loadingStep: LoadingStep
    let hasExistingStory: Bool
    @State private var progressAnimation: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showChapterReady: Bool = false
    
    private var loadingStages: [LoadingStep] {
        [.idle, .buildingStory, .refiningDetails, .expandingNarrative, .addingDepth, .finalizingStory]
    }
    
    private var currentStageIndex: Int {
        loadingStages.firstIndex(of: loadingStep) ?? 0
    }
    
    private var stageProgress: CGFloat {
        guard loadingStages.count > 1 else { return 0 }
        return CGFloat(currentStageIndex) / CGFloat(loadingStages.count - 1)
    }
    
    private var stageTitle: String {
        switch loadingStep {
        case .idle:
            return "Preparing"
        case .buildingStory:
            return "Building Story"
        case .refiningDetails:
            return "Refining Details"
        case .expandingNarrative:
            return "Expanding Narrative"
        case .addingDepth:
            return "Adding Depth"
        case .finalizingStory:
            return "Finalizing"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if showChapterReady && hasExistingStory {
                // Chapter ready message
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.2, green: 0.6, blue: 0.3),
                                        Color(red: 0.1, green: 0.5, blue: 0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                            .scaleEffect(pulseScale)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 1.2)
                                .repeatForever(autoreverses: true)
                        ) {
                            pulseScale = 1.15
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Chapter Ready!")
                            .font(.custom("Georgia", size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.3))
                        
                        Text("Tap to view your new chapter")
                            .font(.custom("Georgia", size: 12))
                            .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                    }
                    
                    Spacer()
                }
                
                // Subtitle
                HStack {
                    Text("Your story continues to unfold...")
                        .font(.custom("Georgia", size: 13))
                        .italic()
                        .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                    
                    Spacer()
                }
            } else {
                // Normal loading state
                HStack(spacing: 12) {
                    // Animated writing indicator
                    ZStack {
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
                            .frame(width: 32, height: 32)
                            .scaleEffect(pulseScale)
                            .overlay(
                                Circle()
                                    .stroke(Color(red: 0.5, green: 0.35, blue: 0.2).opacity(0.3), lineWidth: 1)
                            )
                        
                        Image(systemName: "pencil.tip")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.35, green: 0.30, blue: 0.25))
                    }
                    .onAppear {
                        withAnimation(
                            Animation.easeInOut(duration: 1.8)
                                .repeatForever(autoreverses: true)
                        ) {
                            pulseScale = 1.1
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(stageTitle)
                                .font(.custom("Georgia", size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                            
                            Spacer()
                            
                            Text("Step \(currentStageIndex + 1) of \(loadingStages.count)")
                                .font(.custom("Georgia", size: 12))
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                        }
                        
                        // Progress bar
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                // Background track
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.2))
                                    .frame(height: 3)
                                
                                // Progress fill with subtle gradient
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 0.5, green: 0.35, blue: 0.2),
                                                Color(red: 0.6, green: 0.45, blue: 0.3)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geometry.size.width * progressAnimation, height: 3)
                                    .animation(.easeOut(duration: 0.8), value: progressAnimation)
                            }
                        }
                        .frame(height: 3)
                    }
                }
                
                // Subtitle
                HStack {
                    Text("Every great story begins with a single word")
                        .font(.custom("Georgia", size: 13))
                        .italic()
                        .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.95),
                            Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.95)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    Rectangle()
                        .stroke(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.1), lineWidth: 0.5)
                        .blur(radius: 0.5)
                )
        )
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                progressAnimation = stageProgress
            }
            
            // Show chapter ready message if story exists and loading is complete
            if hasExistingStory && loadingStep == .idle {
                showChapterReady = true
                // Hide the message after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showChapterReady = false
                    }
                }
            }
        }
        .onChange(of: loadingStep) { oldStep, newStep in
            withAnimation(.easeOut(duration: 0.8)) {
                progressAnimation = stageProgress
            }
            
            // Show chapter ready message when transitioning to idle with existing story
            if hasExistingStory && oldStep != .idle && newStep == .idle {
                withAnimation(.easeIn(duration: 0.3)) {
                    showChapterReady = true
                }
                // Hide the message after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showChapterReady = false
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: stageTitle)
    }
}

#Preview {
    VStack(spacing: 0) {
        // Simulated top bar
        HStack {
            Image(systemName: "text.alignleft")
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                .padding()
            Spacer()
        }
        .background(Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.8))
        
        // Loading bar
        LoadingView(loadingStep: .buildingStory, hasExistingStory: false)
        
        // Simulated content
        Rectangle()
            .fill(Color(red: 0.98, green: 0.95, blue: 0.89))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Finalizing Stage") {
    VStack(spacing: 0) {
        HStack {
            Image(systemName: "text.alignleft")
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                .padding()
            Spacer()
        }
        .background(Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.8))
        
        LoadingView(loadingStep: .finalizingStory, hasExistingStory: false)
        
        Rectangle()
            .fill(Color(red: 0.98, green: 0.95, blue: 0.89))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Chapter Ready") {
    VStack(spacing: 0) {
        HStack {
            Image(systemName: "text.alignleft")
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                .padding()
            Spacer()
        }
        .background(Color(red: 0.98, green: 0.95, blue: 0.89).opacity(0.8))
        
        LoadingView(loadingStep: .idle, hasExistingStory: true)
        
        Rectangle()
            .fill(Color(red: 0.98, green: 0.95, blue: 0.89))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Adding Depth Stage") {
    LoadingView(loadingStep: .addingDepth, hasExistingStory: false)
        .previewLayout(.sizeThatFits)
}
