//
//  MockSettingsEnvironment.swift
//  Settings
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Foundation
import Combine
@testable import Settings

public class MockSettingsEnvironment: SettingsEnvironmentProtocol {
    
    // MARK: - Spy Properties for Method Calls
    public var loadSettingsCalled = false
    public var loadSettingsCallCount = 0
    
    public var saveSettingsCalled = false
    public var saveSettingsCalledWith: SettingsState?
    public var saveSettingsCallCount = 0
    public var saveSettingsCallHistory: [SettingsState] = []
    
    // MARK: - Return Values and Error Configuration
    public var loadSettingsReturnValue: SettingsState = SettingsState()
    public var loadSettingsError: Error?
    
    public var saveSettingsError: Error?
    
    // MARK: - Protocol Properties
    public var settingsSubject: CurrentValueSubject<SettingsState?, Never>
    
    // MARK: - Initialization
    public init(
        initialSettings: SettingsState? = nil
    ) {
        self.settingsSubject = CurrentValueSubject<SettingsState?, Never>(initialSettings)
    }
    
    // MARK: - SettingsEnvironmentProtocol Methods
    
    public func loadSettings() async throws -> SettingsState {
        loadSettingsCalled = true
        loadSettingsCallCount += 1
        
        if let error = loadSettingsError {
            throw error
        }
        
        settingsSubject.send(loadSettingsReturnValue)
        return loadSettingsReturnValue
    }
    
    public func saveSettings(_ settings: SettingsState) async throws {
        saveSettingsCalled = true
        saveSettingsCalledWith = settings
        saveSettingsCallCount += 1
        saveSettingsCallHistory.append(settings)
        
        if let error = saveSettingsError {
            throw error
        }
        
        settingsSubject.send(settings)
    }
    
    // MARK: - Helper Methods
    
    public func reset() {
        loadSettingsCalled = false
        loadSettingsCallCount = 0
        
        saveSettingsCalled = false
        saveSettingsCalledWith = nil
        saveSettingsCallCount = 0
        saveSettingsCallHistory.removeAll()
        
        loadSettingsReturnValue = SettingsState()
        loadSettingsError = nil
        saveSettingsError = nil
        
        settingsSubject.send(nil)
    }
}

// MARK: - Test Error

public struct SettingsTestError: Error, Equatable {
    public let message: String
    
    public init(_ message: String = "Settings test error") {
        self.message = message
    }
}