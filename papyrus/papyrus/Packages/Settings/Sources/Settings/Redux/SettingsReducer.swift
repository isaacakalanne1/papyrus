import Foundation
import ReduxKit

@MainActor
public let settingsReducer: Reducer<SettingsState, SettingsAction> = { state, action in
    var newState = state

    switch action {
    case .selectTextSize(let size):
        newState.selectedTextSize = size
    case .selectFont(let fontName):
        newState.selectedFontName = fontName
    case .selectColorScheme(let schemeName):
        newState.selectedColorSchemeName = schemeName
    case .addBackgroundImage(let entry):
        newState.backgroundImages.append(entry)
        newState.selectedBackgroundImageId = entry.id
    case .selectBackgroundImage(let id):
        newState.selectedBackgroundImageId = id
    case .deleteBackgroundImage(let id):
        newState.backgroundImages.removeAll { $0.id == id }
        if newState.selectedBackgroundImageId == id {
            newState.selectedBackgroundImageId = nil
        }
    case .setBackgroundImageUsage(let contexts):
        newState.backgroundImageUsage = contexts
    case .setSentenceCount(let count):
        newState.sentenceCount = count
    case .onLoadedSettings(let settings):
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
