import Foundation
import PapyrusStyleKit

public struct SettingsState: Equatable, Codable, Sendable {
    public var selectedTextSize: TextSize
    public var isSubscribed: Bool
    public var perspective: StoryPerspective
    public var selectedFontName: String
    public var selectedColorSchemeName: PapyrusColorSchemeName
    public var storyMode: StoryMode
    public var backgroundImageData: Data?
    public var backgroundImageUsage: Set<BackgroundImageContext>

    public init(
        selectedTextSize: TextSize = .medium,
        isSubscribed: Bool = false,
        perspective: StoryPerspective = .thirdPerson,
        selectedFontName: String = "Georgia",
        selectedColorSchemeName: PapyrusColorSchemeName = .parchment,
        storyMode: StoryMode = .story,
        backgroundImageData: Data? = nil,
        backgroundImageUsage: Set<BackgroundImageContext> = []
    ) {
        self.selectedTextSize = selectedTextSize
        self.isSubscribed = isSubscribed
        self.perspective = perspective
        self.selectedFontName = selectedFontName
        self.selectedColorSchemeName = selectedColorSchemeName
        self.storyMode = storyMode
        self.backgroundImageData = backgroundImageData
        self.backgroundImageUsage = backgroundImageUsage
    }

    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.selectedTextSize = try container.decode(TextSize.self, forKey: .selectedTextSize)
        self.isSubscribed = try container.decode(Bool.self, forKey: .isSubscribed)
        self.perspective = try container.decodeIfPresent(StoryPerspective.self, forKey: .perspective) ?? .thirdPerson
        self.selectedFontName = try container.decodeIfPresent(String.self, forKey: .selectedFontName) ?? "Georgia"
        self.selectedColorSchemeName = try container.decodeIfPresent(PapyrusColorSchemeName.self, forKey: .selectedColorSchemeName) ?? .parchment
        self.storyMode = try container.decodeIfPresent(StoryMode.self, forKey: .storyMode) ?? .story
        self.backgroundImageData = try container.decodeIfPresent(Data.self, forKey: .backgroundImageData)
        self.backgroundImageUsage = try container.decodeIfPresent(Set<BackgroundImageContext>.self, forKey: .backgroundImageUsage) ?? []
    }
}
