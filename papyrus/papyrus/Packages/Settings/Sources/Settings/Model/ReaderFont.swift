import Foundation

public enum ReaderFont: String, CaseIterable, Codable, Sendable, Equatable {
    case georgia
    case palatino
    case baskerville
    case iowan
    case charter

    public var displayName: String {
        switch self {
        case .georgia:
            return "Georgia"
        case .palatino:
            return "Palatino"
        case .baskerville:
            return "Baskerville"
        case .iowan:
            return "Iowan Old Style"
        case .charter:
            return "Charter"
        }
    }

    public var fontName: String {
        switch self {
        case .georgia:
            return "Georgia"
        case .palatino:
            return "Palatino-Roman"
        case .baskerville:
            return "Baskerville"
        case .iowan:
            return "IowanOldStyle-Roman"
        case .charter:
            return "Charter-Roman"
        }
    }
}
