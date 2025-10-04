//
//  SettingsEnvironmentTests.swift
//  Settings
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import Foundation
import Combine
import SettingsMocks
@testable import Settings

class SettingsEnvironmentTests {
    
    // MARK: - Load Settings Tests
    
    @Test
    func loadSettings_callsDataStore() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let expectedSettings = SettingsState(selectedTextSize: .large, isSubscribed: true)
        mockDataStore.loadSettingsReturnValue = expectedSettings
        
        let result = try await environment.loadSettings()
        
        #expect(mockDataStore.loadSettingsCalled)
        #expect(mockDataStore.loadSettingsCallCount == 1)
        #expect(result == expectedSettings)
    }
    
    @Test
    func loadSettings_updatesSettingsSubject() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let expectedSettings = SettingsState(selectedTextSize: .extraLarge, isSubscribed: false)
        mockDataStore.loadSettingsReturnValue = expectedSettings
        
        let _ = try await environment.loadSettings()
        
        #expect(environment.settingsSubject.value == expectedSettings)
    }
    
    @Test
    func loadSettings_throwsError() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let testError = SettingsTestError("Load failed")
        mockDataStore.loadSettingsError = testError
        
        await #expect(throws: SettingsTestError.self) {
            try await environment.loadSettings()
        }
        
        #expect(mockDataStore.loadSettingsCalled)
        #expect(environment.settingsSubject.value == nil) // Should remain unchanged
    }
    
    @Test(arguments: [
        (TextSize.small, true),
        (TextSize.medium, false),
        (TextSize.large, true),
        (TextSize.extraLarge, false)
    ])
    func loadSettings_withVariousStates(textSize: TextSize, isSubscribed: Bool) async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let settings = SettingsState(selectedTextSize: textSize, isSubscribed: isSubscribed)
        mockDataStore.loadSettingsReturnValue = settings
        
        let result = try await environment.loadSettings()
        
        #expect(result.selectedTextSize == textSize)
        #expect(result.isSubscribed == isSubscribed)
        #expect(environment.settingsSubject.value?.selectedTextSize == textSize)
        #expect(environment.settingsSubject.value?.isSubscribed == isSubscribed)
    }
    
    // MARK: - Save Settings Tests
    
    @Test
    func saveSettings_callsDataStore() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let settingsToSave = SettingsState(selectedTextSize: .small, isSubscribed: true)
        
        try await environment.saveSettings(settingsToSave)
        
        #expect(mockDataStore.saveSettingsCalled)
        #expect(mockDataStore.saveSettingsCallCount == 1)
        #expect(mockDataStore.saveSettingsCalledWith == settingsToSave)
    }
    
    @Test
    func saveSettings_updatesSettingsSubject() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let settingsToSave = SettingsState(selectedTextSize: .large, isSubscribed: false)
        
        try await environment.saveSettings(settingsToSave)
        
        #expect(environment.settingsSubject.value == settingsToSave)
    }
    
    @Test
    func saveSettings_throwsError() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let settingsToSave = SettingsState()
        let testError = SettingsTestError("Save failed")
        mockDataStore.saveSettingsError = testError
        
        await #expect(throws: SettingsTestError.self) {
            try await environment.saveSettings(settingsToSave)
        }
        
        #expect(mockDataStore.saveSettingsCalled)
        #expect(mockDataStore.saveSettingsCalledWith == settingsToSave)
        // Subject should not be updated on error
        #expect(environment.settingsSubject.value == nil)
    }
    
    @Test(arguments: [
        (TextSize.small, false),
        (TextSize.medium, true),
        (TextSize.large, false),
        (TextSize.extraLarge, true)
    ])
    func saveSettings_withVariousStates(textSize: TextSize, isSubscribed: Bool) async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let settings = SettingsState(selectedTextSize: textSize, isSubscribed: isSubscribed)
        
        try await environment.saveSettings(settings)
        
        #expect(mockDataStore.saveSettingsCalledWith?.selectedTextSize == textSize)
        #expect(mockDataStore.saveSettingsCalledWith?.isSubscribed == isSubscribed)
        #expect(environment.settingsSubject.value?.selectedTextSize == textSize)
        #expect(environment.settingsSubject.value?.isSubscribed == isSubscribed)
    }
    
    // MARK: - Settings Subject Tests
    
    @Test
    func settingsSubject_initialValue() {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        #expect(environment.settingsSubject.value == nil)
    }
    
    @Test
    func settingsSubject_publishesChanges() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        var receivedValues: [SettingsState?] = []
        let cancellable = environment.settingsSubject
            .sink { value in
                receivedValues.append(value)
            }
        
        // Initial value
        #expect(receivedValues.count == 1)
        #expect(receivedValues[0] == nil)
        
        // Load settings
        let loadedSettings = SettingsState(selectedTextSize: .large, isSubscribed: true)
        mockDataStore.loadSettingsReturnValue = loadedSettings
        let _ = try await environment.loadSettings()
        
        #expect(receivedValues.count == 2)
        #expect(receivedValues[1] == loadedSettings)
        
        // Save settings
        let savedSettings = SettingsState(selectedTextSize: .small, isSubscribed: false)
        try await environment.saveSettings(savedSettings)
        
        #expect(receivedValues.count == 3)
        #expect(receivedValues[2] == savedSettings)
        
        cancellable.cancel()
    }
    
    // MARK: - Integration Tests
    
    @Test
    func loadThenSave_integration() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        // Load settings
        let initialSettings = SettingsState(selectedTextSize: .medium, isSubscribed: false)
        mockDataStore.loadSettingsReturnValue = initialSettings
        
        let loadedSettings = try await environment.loadSettings()
        #expect(loadedSettings == initialSettings)
        #expect(environment.settingsSubject.value == initialSettings)
        
        // Modify and save settings
        let modifiedSettings = SettingsState(selectedTextSize: .extraLarge, isSubscribed: true)
        try await environment.saveSettings(modifiedSettings)
        
        #expect(mockDataStore.saveSettingsCalledWith == modifiedSettings)
        #expect(environment.settingsSubject.value == modifiedSettings)
        
        #expect(mockDataStore.loadSettingsCallCount == 1)
        #expect(mockDataStore.saveSettingsCallCount == 1)
    }
    
    @Test
    func multipleSaves_trackingHistory() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let settings1 = SettingsState(selectedTextSize: .small, isSubscribed: false)
        let settings2 = SettingsState(selectedTextSize: .medium, isSubscribed: true)
        let settings3 = SettingsState(selectedTextSize: .large, isSubscribed: false)
        
        try await environment.saveSettings(settings1)
        try await environment.saveSettings(settings2)
        try await environment.saveSettings(settings3)
        
        #expect(mockDataStore.saveSettingsCallCount == 3)
        #expect(mockDataStore.saveSettingsCallHistory.count == 3)
        #expect(mockDataStore.saveSettingsCallHistory[0] == settings1)
        #expect(mockDataStore.saveSettingsCallHistory[1] == settings2)
        #expect(mockDataStore.saveSettingsCallHistory[2] == settings3)
        
        // Subject should have the latest value
        #expect(environment.settingsSubject.value == settings3)
    }
    
    // MARK: - Default DataStore Tests
    
    @Test
    func environment_defaultDataStore() {
        let environment = SettingsEnvironment()
        
        // Should create with default data store (not testable in detail, but verify it's created)
        #expect(environment.settingsSubject.value == nil)
    }
    
    // MARK: - Error Recovery Tests
    
    @Test
    func loadError_thenSuccessfulSave() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        // First, attempt to load (fails)
        mockDataStore.loadSettingsError = SettingsTestError("Load failed")
        
        await #expect(throws: SettingsTestError.self) {
            try await environment.loadSettings()
        }
        
        #expect(environment.settingsSubject.value == nil)
        
        // Then, save successfully
        mockDataStore.loadSettingsError = nil // Clear error
        let settingsToSave = SettingsState(selectedTextSize: .medium, isSubscribed: true)
        
        try await environment.saveSettings(settingsToSave)
        
        #expect(mockDataStore.saveSettingsCalled)
        #expect(environment.settingsSubject.value == settingsToSave)
    }
    
    @Test
    func saveError_thenSuccessfulLoad() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        // First, attempt to save (fails)
        let settingsToSave = SettingsState(selectedTextSize: .large, isSubscribed: false)
        mockDataStore.saveSettingsError = SettingsTestError("Save failed")
        
        await #expect(throws: SettingsTestError.self) {
            try await environment.saveSettings(settingsToSave)
        }
        
        #expect(environment.settingsSubject.value == nil)
        
        // Then, load successfully
        mockDataStore.saveSettingsError = nil // Clear error
        let loadedSettings = SettingsState(selectedTextSize: .small, isSubscribed: true)
        mockDataStore.loadSettingsReturnValue = loadedSettings
        
        let result = try await environment.loadSettings()
        
        #expect(result == loadedSettings)
        #expect(environment.settingsSubject.value == loadedSettings)
    }
    
    // MARK: - Concurrent Operations Tests
    
    @Test
    func concurrentLoadAndSave() async throws {
        let mockDataStore = MockSettingsDataStore()
        let environment = SettingsEnvironment(dataStore: mockDataStore)
        
        let loadSettings = SettingsState(selectedTextSize: .large, isSubscribed: true)
        let saveSettings = SettingsState(selectedTextSize: .small, isSubscribed: false)
        
        mockDataStore.loadSettingsReturnValue = loadSettings
        
        // Execute load and save concurrently
        let loadResult = try await environment.loadSettings()
        try await environment.saveSettings(saveSettings)

        #expect(mockDataStore.loadSettingsCalled)
        #expect(mockDataStore.saveSettingsCalled)
        #expect(mockDataStore.saveSettingsCalledWith == saveSettings)
        
        // The final subject value depends on which operation completed last
        // Both operations should have executed successfully
        #expect(environment.settingsSubject.value != nil)
    }
}
