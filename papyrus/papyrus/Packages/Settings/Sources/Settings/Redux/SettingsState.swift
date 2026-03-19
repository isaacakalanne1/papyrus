import Foundation

public struct SettingsState: Equatable, Codable, Sendable {
    public var selectedTextSize: TextSize
    public var isSubscribed: Bool
    public var perspective: StoryPerspective
    public var selectedFont: ReaderFont

    public init(
        selectedTextSize: TextSize = .medium,
        isSubscribed: Bool = false,
        perspective: StoryPerspective = .thirdPerson,
        selectedFont: ReaderFont = .georgia
    ) {
        self.selectedTextSize = selectedTextSize
        self.isSubscribed = isSubscribed
        self.perspective = perspective
        self.selectedFont = selectedFont
    }

    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.selectedTextSize = try container.decode(TextSize.self, forKey: .selectedTextSize)
        self.isSubscribed = try container.decode(Bool.self, forKey: .isSubscribed)
        self.perspective = try container.decodeIfPresent(StoryPerspective.self, forKey: .perspective) ?? .thirdPerson
        self.selectedFont = try container.decodeIfPresent(ReaderFont.self, forKey: .selectedFont) ?? .georgia
    }
}
