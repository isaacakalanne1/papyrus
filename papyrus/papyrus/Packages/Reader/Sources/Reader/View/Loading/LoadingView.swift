//
//  LoadingView.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import PapyrusStyleKit
import SwiftUI

struct LoadingView: View {
    let loadingDisplayStep: LoadingStep
    let hasExistingStory: Bool
    let fontName: String
    @State private var progressAnimation: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var showChapterReady: Bool = false
    @Environment(\.papyrusColorScheme) private var colorScheme

    init(loadingDisplayStep: LoadingStep, hasExistingStory: Bool, fontName: String = "Georgia") {
        self.loadingDisplayStep = loadingDisplayStep
        self.hasExistingStory = hasExistingStory
        self.fontName = fontName
    }

    private var storyCreationStages: [LoadingStep] {
        [.identifyingTheme, .creatingPlotOutline, .condensingPlotOutline, .creatingChapterBreakdown, .parsingChapterSummaries, .analyzingStructure, .preparingNarrative]
    }

    private var currentStageIndex: Int {
        storyCreationStages.firstIndex(of: loadingDisplayStep) ?? 0
    }

    private var stageProgress: CGFloat {
        // Start at 15% for step 1, end at 85% for step 4
        // This leaves room for the "writing chapter" step visually
        let startProgress: CGFloat = 0.15
        let endProgress: CGFloat = 0.85
        let progressRange = endProgress - startProgress

        guard storyCreationStages.count > 1 else { return startProgress }
        let stepProgress = CGFloat(currentStageIndex) / CGFloat(storyCreationStages.count - 1)
        return startProgress + (stepProgress * progressRange)
    }

    private var stageTitle: String {
        switch loadingDisplayStep {
        case .idle, .preparing:
            return "Preparing"
        case .identifyingTheme:
            return "Identifying Theme"
        case .creatingPlotOutline:
            return "Creating Plot Outline"
        case .condensingPlotOutline:
            return "Distilling Story Premise"
        case .creatingChapterBreakdown:
            return "Planning Chapters"
        case .parsingChapterSummaries:
            return "Mapping Chapter Structure"
        case .analyzingStructure:
            return "Analyzing Structure"
        case .preparingNarrative:
            return "Preparing Narrative"
        case .writingChapter:
            return "Writing Chapter"
        }
    }

    var body: some View {
        Group {
            if loadingDisplayStep == .writingChapter {
                ChapterWritingLoadingView(fontName: fontName)
            } else if showChapterReady && hasExistingStory {
                chapterReadyView
            } else if storyCreationStages.contains(loadingDisplayStep) {
                storyCreationLoadingView
            }
        }
        .onAppear {
            if storyCreationStages.contains(loadingDisplayStep) {
                withAnimation(.easeOut(duration: 1.0).delay(0.2)) {
                    progressAnimation = stageProgress
                }
            }

            if hasExistingStory && loadingDisplayStep == .idle {
                showChapterReady = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showChapterReady = false
                    }
                }
            }
        }
        .onChange(of: loadingDisplayStep) { oldStep, newStep in
            if storyCreationStages.contains(newStep) {
                withAnimation(.easeOut(duration: 0.8)) {
                    progressAnimation = stageProgress
                }
            }

            if hasExistingStory && oldStep != .idle && newStep == .idle {
                withAnimation(.easeIn(duration: 0.3)) {
                    showChapterReady = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showChapterReady = false
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: stageTitle)
    }

    private var storyCreationLoadingView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // Animated writing indicator
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.94, green: 0.90, blue: 0.82),
                                    Color(red: 0.92, green: 0.88, blue: 0.79),
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

                    Image(systemName: "book.pages")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(PapyrusColor.borderPrimary.color(in: colorScheme))
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
                            .font(.custom(fontName, size: 15))
                            .fontWeight(.semibold)
                            .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

                        Spacer()

                        Text("Step \(currentStageIndex + 1) of \(storyCreationStages.count + 1)")
                            .font(.custom(fontName, size: 12))
                            .fontWeight(.medium)
                            .foregroundColor(PapyrusColor.iconSecondary.color(in: colorScheme))
                    }

                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: 3)
                                .fill(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.2))
                                .frame(height: 3)

                            // Progress fill with subtle gradient
                            RoundedRectangle(cornerRadius: 3)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 0.5, green: 0.35, blue: 0.2),
                                            Color(red: 0.6, green: 0.45, blue: 0.3),
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
                Text("Crafting your unique story foundation")
                    .font(.custom(fontName, size: 13))
                    .italic()
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))

                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(loadingBackground)
    }

    private var chapterReadyView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.2, green: 0.6, blue: 0.3),
                                    Color(red: 0.1, green: 0.5, blue: 0.2),
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
                        .font(.custom(fontName, size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.2, green: 0.6, blue: 0.3))

                    Text("Your new chapter awaits")
                        .font(.custom(fontName, size: 12))
                        .foregroundColor(PapyrusColor.iconSecondary.color(in: colorScheme))
                }

                Spacer()
            }

            // Subtitle
            HStack {
                Text("Your story continues to unfold...")
                    .font(.custom(fontName, size: 13))
                    .italic()
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))

                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(loadingBackground)
    }

    private var loadingBackground: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        PapyrusColor.background.color(in: colorScheme).opacity(0.95),
                        PapyrusColor.backgroundSecondary.color(in: colorScheme).opacity(0.95),
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Rectangle()
                    .stroke(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.1), lineWidth: 0.5)
                    .blur(radius: 0.5)
            )
    }
}

#Preview("Story Creation") {
    VStack(spacing: 0) {
        LoadingView(loadingDisplayStep: .creatingPlotOutline, hasExistingStory: false)

        Rectangle()
            .fill(PapyrusColor.background.color(in: .parchment))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Chapter Writing") {
    VStack(spacing: 0) {
        LoadingView(loadingDisplayStep: .writingChapter, hasExistingStory: true)

        Rectangle()
            .fill(PapyrusColor.background.color(in: .parchment))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("Chapter Ready") {
    VStack(spacing: 0) {
        LoadingView(loadingDisplayStep: .idle, hasExistingStory: true)

        Rectangle()
            .fill(PapyrusColor.background.color(in: .parchment))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
