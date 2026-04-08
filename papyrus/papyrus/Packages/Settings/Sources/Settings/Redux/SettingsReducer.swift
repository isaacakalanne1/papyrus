import Foundation
import ReduxKit

@MainActor
public let settingsReducer: Reducer<SettingsState, SettingsAction> = { state, action in
    var newState = state

    switch action {
    case let .selectTextSize(size):
        newState.selectedTextSize = size
    case let .selectFont(fontName):
        newState.selectedFontName = fontName
    case let .selectColorScheme(schemeName):
        newState.selectedColorSchemeName = schemeName
    case let .addBackgroundImage(entry):
        newState.backgroundImages.append(entry)
        newState.selectedBackgroundImageId = entry.id
    case let .selectBackgroundImage(id):
        newState.selectedBackgroundImageId = id
    case let .deleteBackgroundImage(id):
        newState.backgroundImages.removeAll { $0.id == id }
        if newState.selectedBackgroundImageId == id {
            newState.selectedBackgroundImageId = nil
        }
    case let .setBackgroundImageUsage(contexts):
        newState.backgroundImageUsage = contexts
    case let .setSentenceCount(count):
        newState.sentenceCount = count
    case let .onLoadedSettings(settings):
        newState = settings
    case .loadSettings,
         .saveSettings,
         .onSavedSettings,
         .failedToLoadSettings,
         .failedToSaveSettings:
        break
    }

    return newState
}
