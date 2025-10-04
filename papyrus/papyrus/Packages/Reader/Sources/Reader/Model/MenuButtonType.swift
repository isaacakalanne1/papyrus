//
//  MenuButtonType.swift
//  Reader
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

enum MenuButtonType {
    case menu
    case settings
    case previous
    case next
    case close
    
    var icon: String {
        switch self {
        case .menu: return "text.alignleft"
        case .settings: return "gearshape"
        case .previous: return "chevron.left"
        case .next: return "chevron.right"
        case .close: return "xmark.circle.fill"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .menu, .settings: return 20
        case .previous, .next: return 16
        case .close: return 24
        }
    }
    
    var frameSize: CGFloat {
        switch self {
        case .menu, .settings: return 44
        case .previous, .next: return 32
        case .close: return 24
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .menu, .settings: return .regular
        case .previous, .next: return .medium
        case .close: return .regular
        }
    }
    
    var color: Color {
        switch self {
        case .close: return Color(red: 0.6, green: 0.5, blue: 0.4)
        default: return Color(red: 0.4, green: 0.35, blue: 0.3)
        }
    }
}
