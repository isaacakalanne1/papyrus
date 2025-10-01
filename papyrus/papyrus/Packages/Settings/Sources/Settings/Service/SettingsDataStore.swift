//
//  SettingsDataStore.swift
//  Settings
//
//  Created by Isaac Akalanne on 01/10/2025.
//

import Foundation

public protocol SettingsDataStoreProtocol {
    func saveSettings(_ settings: SettingsState) async throws
    func loadSettings() async throws -> SettingsState?
}

public class SettingsDataStore: SettingsDataStoreProtocol {
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    private let settingsFileName = "settings.json"
    
    public init() {
        self.documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private var settingsFileURL: URL {
        documentsDirectory.appendingPathComponent(settingsFileName)
    }
    
    public func saveSettings(_ settings: SettingsState) async throws {
        let data = try JSONEncoder().encode(settings)
        try data.write(to: settingsFileURL)
    }
    
    public func loadSettings() async throws -> SettingsState? {
        guard fileManager.fileExists(atPath: settingsFileURL.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: settingsFileURL)
        return try JSONDecoder().decode(SettingsState.self, from: data)
    }
}