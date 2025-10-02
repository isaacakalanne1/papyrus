import Foundation
import ReduxKit

@MainActor
public let settingsReducer: Reducer<SettingsState, SettingsAction> = { state, action in
    var newState = state
    
    switch action {
    case .selectWritingStyle(let style):
        newState.selectedWritingStyle = style
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
