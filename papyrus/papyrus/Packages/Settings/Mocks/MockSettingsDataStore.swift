//
//  MockSettingsDataStore.swift
//  Settings
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Foundation
@testable import Settings

public class MockSettingsDataStore: SettingsDataStoreProtocol {
    
    // MARK: - Spy Properties for Method Calls
    public var saveSettingsCalled = false
    public var saveSettingsCalledWith: SettingsState?
    public var saveSettingsCallCount = 0
    public var saveSettingsCallHistory: [SettingsState] = []
    
    public var loadSettingsCalled = false
    public var loadSettingsCallCount = 0
    
    // MARK: - Return Values and Error Configuration
    public var saveSettingsError: Error?
    
    public var loadSettingsReturnValue: SettingsState = SettingsState()
    public var loadSettingsError: Error?
    
    // MARK: - Storage for Testing
    public var storedSettings: SettingsState?
    
    // MARK: - Initialization
    public init() {}
    
    // MARK: - SettingsDataStoreProtocol Methods
    
    public func saveSettings(_ settings: SettingsState) async throws {
        saveSettingsCalled = true
        saveSettingsCalledWith = settings
        saveSettingsCallCount += 1
        saveSettingsCallHistory.append(settings)
        
        if let error = saveSettingsError {
            throw error
        }
        
        // Update internal storage for realistic behavior
        storedSettings = settings
    }
    
    public func loadSettings() async throws -> SettingsState {
        loadSettingsCalled = true
        loadSettingsCallCount += 1
        
        if let error = loadSettingsError {
            throw error
        }
        
        // Return configured return value or stored settings
        if let storedSettings = storedSettings {
            return storedSettings
        }
        
        return loadSettingsReturnValue
    }
    
    // MARK: - Helper Methods
    
    public func reset() {
        saveSettingsCalled = false
        saveSettingsCalledWith = nil
        saveSettingsCallCount = 0
        saveSettingsCallHistory.removeAll()
        
        loadSettingsCalled = false
        loadSettingsCallCount = 0
        
        saveSettingsError = nil
        loadSettingsReturnValue = SettingsState()
        loadSettingsError = nil
        
        storedSettings = nil
    }
    
    public func setStoredSettings(_ settings: SettingsState) {
        storedSettings = settings
    }
}