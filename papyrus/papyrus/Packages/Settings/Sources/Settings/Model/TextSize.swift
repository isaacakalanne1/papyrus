import SwiftUI

public enum TextSize: String, CaseIterable, Codable, Sendable {
    case small
    case medium
    case large
    case extraLarge
    
    public var fontSize: CGFloat {
        switch self {
        case .small:
            return 16
        case .medium:
            return 18
        case .large:
            return 20
        case .extraLarge:
            return 24
        }
    }
    
    public var iconScale: CGFloat {
        switch self {
        case .small:
            return 0.8
        case .medium:
            return 1.0
        case .large:
            return 1.2
        case .extraLarge:
            return 1.4
        }
    }
}
