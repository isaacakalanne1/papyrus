//
//  PapyrusColor.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public enum PapyrusColor {
    /// Background
    case background
    case backgroundSecondary
    case buttonGradientTop
    case buttonGradientBottom
    
    /// Border
    case border
    
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
        case .buttonGradientBottom:
            Color(red: 0.35, green: 0.30, blue: 0.25)
        case .border:
            Color(red: 0.35, green: 0.30, blue: 0.25)
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
