import Foundation

public enum ReaderFont: String, CaseIterable, Codable, Sendable, Equatable {
    case georgia
    case futura
    case optima
    case americanTypewriter
    case zapfino
    case copperplate

    public var displayName: String {
        switch self {
        case .georgia:
            return "Georgia"
        case .futura:
            return "Futura"
        case .optima:
            return "Optima"
        case .americanTypewriter:
            return "American Typewriter"
        case .zapfino:
            return "Zapfino"
        case .copperplate:
            return "Copperplate"
        }
    }

    public var fontName: String {
        switch self {
        case .georgia:
            return "Georgia"
        case .futura:
            return "Futura-Medium"
        case .optima:
            return "Optima-Regular"
        case .americanTypewriter:
            return "AmericanTypewriter"
        case .zapfino:
            return "Zapfino"
        case .copperplate:
            return "Copperplate"
        }
    }
}
