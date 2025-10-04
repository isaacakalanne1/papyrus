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
}
