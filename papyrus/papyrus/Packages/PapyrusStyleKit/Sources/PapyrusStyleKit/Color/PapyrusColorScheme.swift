//
//  PapyrusColorScheme.swift
//  PapyrusStyleKit
//

import SwiftUI

public struct PapyrusColorScheme: Equatable, Sendable {
    public let background: Color
    public let backgroundSecondary: Color
    public let buttonGradientTop: Color
    public let buttonGradientBottom: Color
    public let borderPrimary: Color
    public let borderSecondary: Color
    public let accent: Color
    public let textPrimary: Color
    public let textSecondary: Color
    public let iconPrimary: Color
    public let iconSecondary: Color
    public let error: Color

    public init(
        background: Color,
        backgroundSecondary: Color,
        buttonGradientTop: Color,
        buttonGradientBottom: Color,
        borderPrimary: Color,
        borderSecondary: Color,
        accent: Color,
        textPrimary: Color,
        textSecondary: Color,
        iconPrimary: Color,
        iconSecondary: Color,
        error: Color
    ) {
        self.background = background
        self.backgroundSecondary = backgroundSecondary
        self.buttonGradientTop = buttonGradientTop
        self.buttonGradientBottom = buttonGradientBottom
        self.borderPrimary = borderPrimary
        self.borderSecondary = borderSecondary
        self.accent = accent
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.iconPrimary = iconPrimary
        self.iconSecondary = iconSecondary
        self.error = error
    }
}

public extension PapyrusColorScheme {
    static let parchment = PapyrusColorScheme(
        background: Color(red: 0.98, green: 0.95, blue: 0.89),
        backgroundSecondary: Color(red: 0.96, green: 0.92, blue: 0.84),
        buttonGradientTop: Color(red: 0.45, green: 0.40, blue: 0.35),
        buttonGradientBottom: Color(red: 0.35, green: 0.30, blue: 0.25),
        borderPrimary: Color(red: 0.35, green: 0.30, blue: 0.25),
        borderSecondary: Color(red: 0.8, green: 0.75, blue: 0.7),
        accent: Color(red: 0.8, green: 0.65, blue: 0.4),
        textPrimary: Color(red: 0.3, green: 0.25, blue: 0.2),
        textSecondary: Color(red: 0.5, green: 0.45, blue: 0.4),
        iconPrimary: Color(red: 0.6, green: 0.5, blue: 0.4),
        iconSecondary: Color(red: 0.4, green: 0.35, blue: 0.3),
        error: Color(red: 0.6, green: 0.3, blue: 0.2)
    )

    static let midnight = PapyrusColorScheme(
        background: Color(red: 0.10, green: 0.12, blue: 0.18),
        backgroundSecondary: Color(red: 0.13, green: 0.16, blue: 0.23),
        buttonGradientTop: Color(red: 0.35, green: 0.45, blue: 0.60),
        buttonGradientBottom: Color(red: 0.25, green: 0.35, blue: 0.50),
        borderPrimary: Color(red: 0.25, green: 0.35, blue: 0.50),
        borderSecondary: Color(red: 0.20, green: 0.28, blue: 0.42),
        accent: Color(red: 0.55, green: 0.75, blue: 0.90),
        textPrimary: Color(red: 0.90, green: 0.92, blue: 0.96),
        textSecondary: Color(red: 0.55, green: 0.62, blue: 0.75),
        iconPrimary: Color(red: 0.65, green: 0.72, blue: 0.85),
        iconSecondary: Color(red: 0.40, green: 0.48, blue: 0.62),
        error: Color(red: 0.85, green: 0.42, blue: 0.42)
    )

    static let sepia = PapyrusColorScheme(
        background: Color(red: 0.94, green: 0.88, blue: 0.76),
        backgroundSecondary: Color(red: 0.90, green: 0.83, blue: 0.68),
        buttonGradientTop: Color(red: 0.72, green: 0.52, blue: 0.28),
        buttonGradientBottom: Color(red: 0.60, green: 0.42, blue: 0.20),
        borderPrimary: Color(red: 0.60, green: 0.48, blue: 0.32),
        borderSecondary: Color(red: 0.75, green: 0.62, blue: 0.45),
        accent: Color(red: 0.72, green: 0.48, blue: 0.22),
        textPrimary: Color(red: 0.25, green: 0.17, blue: 0.08),
        textSecondary: Color(red: 0.50, green: 0.38, blue: 0.22),
        iconPrimary: Color(red: 0.45, green: 0.33, blue: 0.18),
        iconSecondary: Color(red: 0.62, green: 0.50, blue: 0.35),
        error: Color(red: 0.72, green: 0.28, blue: 0.22)
    )

    static let forest = PapyrusColorScheme(
        background: Color(red: 0.13, green: 0.18, blue: 0.13),
        backgroundSecondary: Color(red: 0.16, green: 0.22, blue: 0.16),
        buttonGradientTop: Color(red: 0.35, green: 0.52, blue: 0.30),
        buttonGradientBottom: Color(red: 0.25, green: 0.40, blue: 0.22),
        borderPrimary: Color(red: 0.28, green: 0.40, blue: 0.25),
        borderSecondary: Color(red: 0.22, green: 0.32, blue: 0.20),
        accent: Color(red: 0.55, green: 0.78, blue: 0.45),
        textPrimary: Color(red: 0.88, green: 0.92, blue: 0.84),
        textSecondary: Color(red: 0.58, green: 0.68, blue: 0.52),
        iconPrimary: Color(red: 0.68, green: 0.78, blue: 0.62),
        iconSecondary: Color(red: 0.42, green: 0.52, blue: 0.38),
        error: Color(red: 0.85, green: 0.45, blue: 0.35)
    )

    static let slate = PapyrusColorScheme(
        background: Color(red: 0.18, green: 0.20, blue: 0.24),
        backgroundSecondary: Color(red: 0.22, green: 0.24, blue: 0.29),
        buttonGradientTop: Color(red: 0.42, green: 0.50, blue: 0.62),
        buttonGradientBottom: Color(red: 0.32, green: 0.40, blue: 0.52),
        borderPrimary: Color(red: 0.32, green: 0.38, blue: 0.48),
        borderSecondary: Color(red: 0.26, green: 0.30, blue: 0.38),
        accent: Color(red: 0.62, green: 0.72, blue: 0.88),
        textPrimary: Color(red: 0.88, green: 0.90, blue: 0.94),
        textSecondary: Color(red: 0.58, green: 0.63, blue: 0.72),
        iconPrimary: Color(red: 0.68, green: 0.74, blue: 0.84),
        iconSecondary: Color(red: 0.42, green: 0.48, blue: 0.58),
        error: Color(red: 0.85, green: 0.42, blue: 0.42)
    )

    static let rose = PapyrusColorScheme(
        background: Color(red: 0.97, green: 0.91, blue: 0.91),
        backgroundSecondary: Color(red: 0.93, green: 0.86, blue: 0.86),
        buttonGradientTop: Color(red: 0.75, green: 0.42, blue: 0.48),
        buttonGradientBottom: Color(red: 0.62, green: 0.32, blue: 0.38),
        borderPrimary: Color(red: 0.72, green: 0.52, blue: 0.55),
        borderSecondary: Color(red: 0.82, green: 0.68, blue: 0.70),
        accent: Color(red: 0.72, green: 0.35, blue: 0.42),
        textPrimary: Color(red: 0.28, green: 0.14, blue: 0.16),
        textSecondary: Color(red: 0.52, green: 0.35, blue: 0.38),
        iconPrimary: Color(red: 0.55, green: 0.35, blue: 0.40),
        iconSecondary: Color(red: 0.68, green: 0.52, blue: 0.55),
        error: Color(red: 0.75, green: 0.22, blue: 0.22)
    )

    static let aurora = PapyrusColorScheme(
        background: Color(red: 0.05, green: 0.12, blue: 0.15),
        backgroundSecondary: Color(red: 0.07, green: 0.16, blue: 0.20),
        buttonGradientTop: Color(red: 0.15, green: 0.55, blue: 0.55),
        buttonGradientBottom: Color(red: 0.10, green: 0.42, blue: 0.45),
        borderPrimary: Color(red: 0.15, green: 0.45, blue: 0.50),
        borderSecondary: Color(red: 0.10, green: 0.30, blue: 0.35),
        accent: Color(red: 0.20, green: 0.88, blue: 0.72),
        textPrimary: Color(red: 0.85, green: 0.96, blue: 0.95),
        textSecondary: Color(red: 0.45, green: 0.70, blue: 0.68),
        iconPrimary: Color(red: 0.40, green: 0.78, blue: 0.72),
        iconSecondary: Color(red: 0.20, green: 0.52, blue: 0.50),
        error: Color(red: 0.90, green: 0.40, blue: 0.35)
    )

    static let ember = PapyrusColorScheme(
        background: Color(red: 0.12, green: 0.08, blue: 0.06),
        backgroundSecondary: Color(red: 0.16, green: 0.10, blue: 0.07),
        buttonGradientTop: Color(red: 0.70, green: 0.35, blue: 0.10),
        buttonGradientBottom: Color(red: 0.55, green: 0.25, blue: 0.06),
        borderPrimary: Color(red: 0.50, green: 0.28, blue: 0.12),
        borderSecondary: Color(red: 0.30, green: 0.18, blue: 0.08),
        accent: Color(red: 0.95, green: 0.55, blue: 0.15),
        textPrimary: Color(red: 0.95, green: 0.88, blue: 0.78),
        textSecondary: Color(red: 0.65, green: 0.50, blue: 0.35),
        iconPrimary: Color(red: 0.80, green: 0.58, blue: 0.35),
        iconSecondary: Color(red: 0.50, green: 0.35, blue: 0.18),
        error: Color(red: 0.92, green: 0.30, blue: 0.20)
    )

    static let lavender = PapyrusColorScheme(
        background: Color(red: 0.94, green: 0.91, blue: 0.98),
        backgroundSecondary: Color(red: 0.90, green: 0.86, blue: 0.96),
        buttonGradientTop: Color(red: 0.58, green: 0.42, blue: 0.80),
        buttonGradientBottom: Color(red: 0.48, green: 0.32, blue: 0.70),
        borderPrimary: Color(red: 0.62, green: 0.48, blue: 0.78),
        borderSecondary: Color(red: 0.78, green: 0.70, blue: 0.90),
        accent: Color(red: 0.55, green: 0.35, blue: 0.82),
        textPrimary: Color(red: 0.22, green: 0.14, blue: 0.38),
        textSecondary: Color(red: 0.48, green: 0.38, blue: 0.62),
        iconPrimary: Color(red: 0.50, green: 0.38, blue: 0.70),
        iconSecondary: Color(red: 0.65, green: 0.55, blue: 0.80),
        error: Color(red: 0.80, green: 0.25, blue: 0.35)
    )

    static let dusk = PapyrusColorScheme(
        background: Color(red: 0.16, green: 0.12, blue: 0.22),
        backgroundSecondary: Color(red: 0.20, green: 0.15, blue: 0.28),
        buttonGradientTop: Color(red: 0.55, green: 0.38, blue: 0.68),
        buttonGradientBottom: Color(red: 0.42, green: 0.28, blue: 0.55),
        borderPrimary: Color(red: 0.42, green: 0.30, blue: 0.58),
        borderSecondary: Color(red: 0.28, green: 0.20, blue: 0.40),
        accent: Color(red: 0.92, green: 0.68, blue: 0.55),
        textPrimary: Color(red: 0.92, green: 0.88, blue: 0.96),
        textSecondary: Color(red: 0.62, green: 0.55, blue: 0.75),
        iconPrimary: Color(red: 0.75, green: 0.65, blue: 0.88),
        iconSecondary: Color(red: 0.48, green: 0.40, blue: 0.60),
        error: Color(red: 0.90, green: 0.42, blue: 0.45)
    )

    static let citrus = PapyrusColorScheme(
        background: Color(red: 0.99, green: 0.97, blue: 0.82),
        backgroundSecondary: Color(red: 0.97, green: 0.93, blue: 0.72),
        buttonGradientTop: Color(red: 0.92, green: 0.58, blue: 0.12),
        buttonGradientBottom: Color(red: 0.80, green: 0.42, blue: 0.06),
        borderPrimary: Color(red: 0.85, green: 0.55, blue: 0.15),
        borderSecondary: Color(red: 0.92, green: 0.78, blue: 0.45),
        accent: Color(red: 0.95, green: 0.50, blue: 0.05),
        textPrimary: Color(red: 0.25, green: 0.15, blue: 0.02),
        textSecondary: Color(red: 0.55, green: 0.38, blue: 0.10),
        iconPrimary: Color(red: 0.70, green: 0.45, blue: 0.12),
        iconSecondary: Color(red: 0.85, green: 0.65, blue: 0.30),
        error: Color(red: 0.80, green: 0.18, blue: 0.10)
    )

    static let copper = PapyrusColorScheme(
        background: Color(red: 0.15, green: 0.09, blue: 0.06),
        backgroundSecondary: Color(red: 0.20, green: 0.12, blue: 0.07),
        buttonGradientTop: Color(red: 0.72, green: 0.42, blue: 0.20),
        buttonGradientBottom: Color(red: 0.58, green: 0.32, blue: 0.14),
        borderPrimary: Color(red: 0.55, green: 0.35, blue: 0.18),
        borderSecondary: Color(red: 0.32, green: 0.20, blue: 0.10),
        accent: Color(red: 0.88, green: 0.58, blue: 0.28),
        textPrimary: Color(red: 0.96, green: 0.88, blue: 0.78),
        textSecondary: Color(red: 0.68, green: 0.52, blue: 0.38),
        iconPrimary: Color(red: 0.78, green: 0.58, blue: 0.38),
        iconSecondary: Color(red: 0.52, green: 0.35, blue: 0.20),
        error: Color(red: 0.90, green: 0.32, blue: 0.22)
    )

    static let obsidian = PapyrusColorScheme(
        background: Color(white: 0.00),
        backgroundSecondary: Color(white: 0.07),
        buttonGradientTop: Color(white: 0.40),
        buttonGradientBottom: Color(white: 0.28),
        borderPrimary: Color(white: 0.30),
        borderSecondary: Color(white: 0.18),
        accent: Color(white: 0.80),
        textPrimary: Color(white: 1.00),
        textSecondary: Color(white: 0.60),
        iconPrimary: Color(white: 0.70),
        iconSecondary: Color(white: 0.40),
        error: Color(red: 0.90, green: 0.35, blue: 0.35)
    )

    static let paper = PapyrusColorScheme(
        background: Color(white: 1.00),
        backgroundSecondary: Color(white: 0.93),
        buttonGradientTop: Color(white: 0.55),
        buttonGradientBottom: Color(white: 0.42),
        borderPrimary: Color(white: 0.65),
        borderSecondary: Color(white: 0.80),
        accent: Color(white: 0.20),
        textPrimary: Color(white: 0.00),
        textSecondary: Color(white: 0.40),
        iconPrimary: Color(white: 0.30),
        iconSecondary: Color(white: 0.55),
        error: Color(red: 0.75, green: 0.15, blue: 0.15)
    )
}

public enum PapyrusColorSchemeName: String, CaseIterable, Codable, Equatable, Sendable {
    case parchment
    case midnight
    case sepia
    case forest
    case slate
    case rose
    case aurora
    case ember
    case lavender
    case dusk
    case citrus
    case copper
    case obsidian
    case paper

    public var displayName: String {
        switch self {
        case .parchment: return "Parchment"
        case .midnight: return "Midnight"
        case .sepia: return "Sepia"
        case .forest: return "Forest"
        case .slate: return "Slate"
        case .rose: return "Rose"
        case .aurora: return "Aurora"
        case .ember: return "Ember"
        case .lavender: return "Lavender"
        case .dusk: return "Dusk"
        case .citrus: return "Citrus"
        case .copper: return "Copper"
        case .obsidian: return "Obsidian"
        case .paper: return "Paper"
        }
    }

    public var scheme: PapyrusColorScheme {
        switch self {
        case .parchment: return .parchment
        case .midnight: return .midnight
        case .sepia: return .sepia
        case .forest: return .forest
        case .slate: return .slate
        case .rose: return .rose
        case .aurora: return .aurora
        case .ember: return .ember
        case .lavender: return .lavender
        case .dusk: return .dusk
        case .citrus: return .citrus
        case .copper: return .copper
        case .obsidian: return .obsidian
        case .paper: return .paper
        }
    }
}
