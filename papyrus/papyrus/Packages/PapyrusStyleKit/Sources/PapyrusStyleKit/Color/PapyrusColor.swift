//
//  PapyrusColor.swift
//  PapyrusStyleKit
//
//  Created by Isaac Akalanne on 05/10/2025.
//

import SwiftUI

public enum PapyrusColor {
    case background
    case textPrimary
    case textSecondary
    case iconPrimary
    case iconSecondary
    
    public var color: Color {
        switch self {
        case .background:
            Color(red: 0.98, green: 0.95, blue: 0.89)
        case .textPrimary:
            Color(red: 0.3, green: 0.25, blue: 0.2)
        case .textSecondary:
            Color(red: 0.5, green: 0.45, blue: 0.4)
        case .iconPrimary:
            Color(red: 0.6, green: 0.5, blue: 0.4)
        case .iconSecondary:
            Color(red: 0.4, green: 0.35, blue: 0.3)
        }
    }
}
