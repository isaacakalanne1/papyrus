import Foundation
import ReduxKit

@MainActor
public let settingsReducer: Reducer<SettingsState, SettingsAction> = { state, action in
    var newState = state
    
    switch action {
    case .selectWritingStyle(let style):
        newState.selectedWritingStyle = style
    case .onLoadedSettings(let loadedSettings):
        if let loadedSettings = loadedSettings {
            newState = loadedSettings
        }
    case .loadSettings,
         .saveSettings,
         .onSavedSettings,
         .failedToLoadSettings,
         .failedToSaveSettings:
        break
    }
    
    return newState
}