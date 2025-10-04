//
//  SettingsEnvironment.swift
//  Settings
//
//  Created by Isaac Akalanne on 01/10/2025.
//

import Foundation
import Combine

public protocol SettingsEnvironmentProtocol {
    func loadSettings() async throws -> SettingsState
    func saveSettings(_ settings: SettingsState) async throws
    var settingsSubject: CurrentValueSubject<SettingsState?, Never> { get }
}

public class SettingsEnvironment: SettingsEnvironmentProtocol {
    private let dataStore: SettingsDataStoreProtocol
    public var settingsSubject: CurrentValueSubject<SettingsState?, Never> = .init(nil)
    
    public init(
        dataStore: SettingsDataStoreProtocol = SettingsDataStore()
    ) {
        self.dataStore = dataStore
    }
    
    public func loadSettings() async throws -> SettingsState {
        let settings = try await dataStore.loadSettings()
        settingsSubject.send(settings)
        return settings
    }
    
    public func saveSettings(_ settings: SettingsState) async throws {
        try await dataStore.saveSettings(settings)
        settingsSubject.send(settings)
    }
}
