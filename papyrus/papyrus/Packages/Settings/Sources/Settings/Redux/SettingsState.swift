import Foundation

public struct SettingsState: Equatable, Codable, Sendable {
    public var selectedWritingStyle: WritingStyle
    
    public init(selectedWritingStyle: WritingStyle = .classic) {
        self.selectedWritingStyle = selectedWritingStyle
    }
}