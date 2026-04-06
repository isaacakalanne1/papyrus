import Foundation

public enum BackgroundImageContext: String, CaseIterable, Codable, Sendable, Hashable {
    case home
    case story
    case interactiveStory

    public var displayName: String {
        switch self {
        case .home: return "Home"
        case .story: return "Story"
        case .interactiveStory: return "Interactive Story"
        }
    }
}
