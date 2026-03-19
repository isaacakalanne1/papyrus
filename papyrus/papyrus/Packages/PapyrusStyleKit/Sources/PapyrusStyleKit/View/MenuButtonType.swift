//
//  MenuButtonType.swift
//  PapyrusStyleKit
//

import SwiftUI

public enum MenuButtonType {
    case menu
    case settings
    case previous
    case next
    case close

    public var icon: String {
        switch self {
        case .menu: return "text.alignleft"
        case .settings: return "gearshape"
        case .previous: return "chevron.left"
        case .next: return "chevron.right"
        case .close: return "xmark.circle.fill"
        }
    }

    public var size: CGFloat {
        switch self {
        case .menu, .settings: return 20
        case .previous, .next: return 16
        case .close: return 24
        }
    }

    public var frameSize: CGFloat {
        switch self {
        case .menu, .settings: return 44
        case .previous, .next: return 32
        case .close: return 24
        }
    }

    public var weight: Font.Weight {
        switch self {
        case .menu, .settings: return .regular
        case .previous, .next: return .medium
        case .close: return .regular
        }
    }

    public var color: Color {
        switch self {
        case .close: return PapyrusColor.iconPrimary.color
        default: return PapyrusColor.iconSecondary.color
        }
    }
}
