import Foundation
import PapyrusStyleKit

public struct SettingsState: Equatable, Codable, Sendable {
    public var selectedTextSize: TextSize
    public var isSubscribed: Bool
    public var perspective: StoryPerspective
    public var selectedFontName: String
    public var selectedColorSchemeName: PapyrusColorSchemeName
    public var storyMode: StoryMode
    public var backgroundImages: [BackgroundImageEntry]
    public var selectedBackgroundImageId: UUID?
    public var backgroundImageUsage: Set<BackgroundImageContext>
    public var sentenceCount: Int

    public init(
        selectedTextSize: TextSize = .medium,
        isSubscribed: Bool = false,
        perspective: StoryPerspective = .thirdPerson,
        selectedFontName: String = "Georgia",
        selectedColorSchemeName: PapyrusColorSchemeName = .parchment,
        storyMode: StoryMode = .story,
        backgroundImages: [BackgroundImageEntry] = [],
        selectedBackgroundImageId: UUID? = nil,
        backgroundImageUsage: Set<BackgroundImageContext> = [],
        sentenceCount: Int = 3
    ) {
        self.selectedTextSize = selectedTextSize
        self.isSubscribed = isSubscribed
        self.perspective = perspective
        self.selectedFontName = selectedFontName
        self.selectedColorSchemeName = selectedColorSchemeName
        self.storyMode = storyMode
        self.backgroundImages = backgroundImages
        self.selectedBackgroundImageId = selectedBackgroundImageId
        self.backgroundImageUsage = backgroundImageUsage
        self.sentenceCount = sentenceCount
    }

    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        selectedTextSize = try container.decode(TextSize.self, forKey: .selectedTextSize)
        isSubscribed = try container.decode(Bool.self, forKey: .isSubscribed)
        perspective = try container.decodeIfPresent(StoryPerspective.self, forKey: .perspective) ?? .thirdPerson
        selectedFontName = try container.decodeIfPresent(String.self, forKey: .selectedFontName) ?? "Georgia"
        selectedColorSchemeName = try container.decodeIfPresent(PapyrusColorSchemeName.self, forKey: .selectedColorSchemeName) ?? .parchment
        storyMode = try container.decodeIfPresent(StoryMode.self, forKey: .storyMode) ?? .story
        backgroundImages = try container.decodeIfPresent([BackgroundImageEntry].self, forKey: .backgroundImages) ?? []
        selectedBackgroundImageId = try container.decodeIfPresent(UUID.self, forKey: .selectedBackgroundImageId)
        backgroundImageUsage = try container.decodeIfPresent(Set<BackgroundImageContext>.self, forKey: .backgroundImageUsage) ?? []
        sentenceCount = try container.decodeIfPresent(Int.self, forKey: .sentenceCount) ?? 3
    }
}
