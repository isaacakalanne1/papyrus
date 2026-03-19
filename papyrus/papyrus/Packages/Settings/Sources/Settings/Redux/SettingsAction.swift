import Foundation
import PapyrusStyleKit

public enum SettingsAction: Equatable, Sendable {
    case selectTextSize(TextSize)
    case selectFont(String)
    case selectColorScheme(PapyrusColorSchemeName)
    case loadSettings
    case onLoadedSettings(SettingsState)
    case saveSettings
    case onSavedSettings
    case failedToLoadSettings
    case failedToSaveSettings
}
