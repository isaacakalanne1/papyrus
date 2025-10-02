import Foundation

public enum SettingsAction: Sendable {
    case selectWritingStyle(WritingStyle)
    case loadSettings
    case onLoadedSettings(SettingsState)
    case saveSettings
    case onSavedSettings
    case failedToLoadSettings
    case failedToSaveSettings
}
