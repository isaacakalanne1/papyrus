import Foundation
import PapyrusStyleKit

public enum SettingsAction: Equatable, Sendable {
    case selectTextSize(TextSize)
    case selectFont(String)
    case selectColorScheme(PapyrusColorSchemeName)
    case addBackgroundImage(BackgroundImageEntry)
    case selectBackgroundImage(UUID?)
    case deleteBackgroundImage(UUID)
    case setBackgroundImageUsage(Set<BackgroundImageContext>)
    case setSentenceCount(Int)
    case loadSettings
    case onLoadedSettings(SettingsState)
    case saveSettings
    case onSavedSettings
    case failedToLoadSettings
    case failedToSaveSettings
}
