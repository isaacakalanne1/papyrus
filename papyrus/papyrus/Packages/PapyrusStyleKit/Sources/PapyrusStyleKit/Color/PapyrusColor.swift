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
    
    public var color: Color {
        switch self {
        case .background:
            Color(red: 0.98, green: 0.95, blue: 0.89)
        case .backgroundSecondary:
            Color(red: 0.96, green: 0.92, blue: 0.84)
        case .buttonGradientTop:
            Color(red: 0.45, green: 0.40, blue: 0.35)
        case .buttonGradientBottom,
                .borderPrimary:
            Color(red: 0.35, green: 0.30, blue: 0.25)
        case .borderSecondary:
            Color(red: 0.8, green: 0.75, blue: 0.7)
        case .accent:
            Color(red: 0.8, green: 0.65, blue: 0.4)
        case .textPrimary:
            Color(red: 0.3, green: 0.25, blue: 0.2)
        case .textSecondary:
            Color(red: 0.5, green: 0.45, blue: 0.4)
        case .iconPrimary:
            Color(red: 0.6, green: 0.5, blue: 0.4)
        case .iconSecondary:
            Color(red: 0.4, green: 0.35, blue: 0.3)
        case .error:
            Color(red: 0.6, green: 0.3, blue: 0.2)
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            ForEach(PapyrusColor.allCases, id: \.self) { papyrusColor in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(papyrusColor.color)
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading) {
                        Text(papyrusColor.rawValue)
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.medium)
                        
                        Text(String(describing: papyrusColor.color))
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
    .background(PapyrusColor.background.color)
}
