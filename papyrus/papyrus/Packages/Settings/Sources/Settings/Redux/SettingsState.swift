import Foundation

public struct SettingsState: Equatable, Codable, Sendable {
    public var selectedTextSize: TextSize
    public var isSubscribed: Bool
    
    public init(
        selectedTextSize: TextSize = .medium,
        isSubscribed: Bool = false
    ) {
        self.selectedTextSize = selectedTextSize
        self.isSubscribed = isSubscribed
    }
    
    public init(
        from decoder: any Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.selectedTextSize = try container.decode(TextSize.self, forKey: .selectedTextSize)
        self.isSubscribed = try container.decode(Bool.self, forKey: .isSubscribed)
    }
}
