import Foundation

public enum SettingsAction: Equatable, Sendable {
    case selectTextSize(TextSize)
    case loadSettings
    case onLoadedSettings(SettingsState)
    case saveSettings
    case onSavedSettings
    case failedToLoadSettings
    case failedToSaveSettings
}
