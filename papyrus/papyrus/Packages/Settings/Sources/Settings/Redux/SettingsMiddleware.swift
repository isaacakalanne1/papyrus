//
//  SettingsMiddleware.swift
//  Settings
//
//  Created by Isaac Akalanne on 01/10/2025.
//

import Foundation
import ReduxKit

@MainActor
public let settingsMiddleware: Middleware<SettingsState, SettingsAction, SettingsEnvironmentProtocol> = { state, action, environment in
    switch action {
    case .selectTextSize:
        return .saveSettings
    case .loadSettings:
        do {
            let loadedSettings = try await environment.loadSettings()
            return .onLoadedSettings(loadedSettings)
        } catch {
            return .failedToLoadSettings
        }
    case .saveSettings:
        do {
            try await environment.saveSettings(state)
            return .onSavedSettings
        } catch {
            return .failedToSaveSettings
        }
    case .onLoadedSettings,
         .onSavedSettings,
         .failedToLoadSettings,
         .failedToSaveSettings:
        return nil
    }
}