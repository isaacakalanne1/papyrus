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
