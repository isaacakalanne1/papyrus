import Foundation

public struct SettingsState: Equatable, Codable, Sendable {
    public var selectedTextSize: TextSize
    
    public init(selectedTextSize: TextSize = .medium) {
        self.selectedTextSize = selectedTextSize
    }
}