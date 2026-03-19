//
//  ChapterLoadingIndicator.swift
//  Reader
//
//  Created by Isaac Akalanne on 07/01/2026.
//

import SwiftUI
import PapyrusStyleKit

struct ChapterLoadingIndicator: View {
    let fontName: String
    @State private var pulseOpacity: Double = 0.4
    @State private var moveOffset: CGFloat = -5
    @Environment(\.papyrusColorScheme) private var colorScheme

    init(fontName: String = "Georgia") {
        self.fontName = fontName
    }

    var body: some View {
        VStack(spacing: 16) {
            // Divider line with a central icon
            HStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0),
                                PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.3)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)

                Image(systemName: "pencil.and.outline")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(PapyrusColor.iconPrimary.color(in: colorScheme))
                    .opacity(pulseOpacity)
                    .offset(y: moveOffset)

                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.3),
                                PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1)
            }
            .padding(.horizontal, 40)

            Text("The next chapter is being crafted...")
                .font(.custom(fontName, size: 16))
                .italic()
                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
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
        PapyrusColor.background.color(in: .parchment).ignoresSafeArea()
        ChapterLoadingIndicator()
    }
}
