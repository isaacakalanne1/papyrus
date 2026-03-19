//
//  PapyrusColor.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public enum PapyrusColor: String, CaseIterable, Sendable {
    /// Background
    case background
    case backgroundSecondary
    case buttonGradientTop
    case buttonGradientBottom

    /// Border
    case borderPrimary
    case borderSecondary

    /// Accent
    case accent

    /// Text
    case textPrimary
    case textSecondary

    /// Icon
    case iconPrimary
    case iconSecondary

    /// Error
    case error

    public func color(in scheme: PapyrusColorScheme) -> Color {
        switch self {
        case .background: return scheme.background
        case .backgroundSecondary: return scheme.backgroundSecondary
        case .buttonGradientTop: return scheme.buttonGradientTop
        case .buttonGradientBottom: return scheme.buttonGradientBottom
        case .borderPrimary: return scheme.borderPrimary
        case .borderSecondary: return scheme.borderSecondary
        case .accent: return scheme.accent
        case .textPrimary: return scheme.textPrimary
        case .textSecondary: return scheme.textSecondary
        case .iconPrimary: return scheme.iconPrimary
        case .iconSecondary: return scheme.iconSecondary
        case .error: return scheme.error
        }
    }
}

#Preview {
    let scheme = PapyrusColorScheme.parchment
    ScrollView {
        VStack(spacing: 16) {
            ForEach(PapyrusColor.allCases, id: \.self) { papyrusColor in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(papyrusColor.color(in: scheme))
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(papyrusColor.rawValue)
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.medium)

                        Text(String(describing: papyrusColor.color(in: scheme)))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
    .background(PapyrusColor.background.color(in: scheme))
}
