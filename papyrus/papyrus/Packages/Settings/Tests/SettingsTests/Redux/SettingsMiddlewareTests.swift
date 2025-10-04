//
//  SettingsMiddlewareTests.swift
//  Settings
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import Foundation
import SettingsMocks
@testable import Settings

@MainActor
class SettingsMiddlewareTests {
    
    // MARK: - selectTextSize Action Tests
    
    @Test(arguments: [
        TextSize.small,
        TextSize.medium,
        TextSize.large,
        TextSize.extraLarge
    ])
    func selectTextSize_returnsSaveSettings(textSize: TextSize) async {
        let state = SettingsState()
        let environment = MockSettingsEnvironment()
        
        let result = await settingsMiddleware(state, .selectTextSize(textSize), environment)
        
        #expect(result == .saveSettings)
        // Environment should not be called for selectTextSize
        #expect(!environment.loadSettingsCalled)
        #expect(!environment.saveSettingsCalled)
    }
    
    // MARK: - loadSettings Action Tests
    
    @Test
    func loadSettings_success_returnsOnLoadedSettings() async {
        let state = SettingsState()
        let environment = MockSettingsEnvironment()
        let expectedSettings = SettingsState(selectedTextSize: .large, isSubscribed: true)
        environment.loadSettingsReturnValue = expectedSettings
        
        let result = await settingsMiddleware(state, .loadSettings, environment)
        
        #expect(environment.loadSettingsCalled)
        #expect(environment.loadSettingsCallCount == 1)
        #expect(result == .onLoadedSettings(expectedSettings))
    }
    
    @Test
    func loadSettings_failure_returnsFailedToLoadSettings() async {
        let state = SettingsState()
        let environment = MockSettingsEnvironment()
        environment.loadSettingsError = SettingsTestError("Load failed")
        
        let result = await settingsMiddleware(state, .loadSettings, environment)
        
        #expect(environment.loadSettingsCalled)
        #expect(result == .failedToLoadSettings)
    }
    
    // MARK: - saveSettings Action Tests
    
    @Test
    func saveSettings_success_returnsOnSavedSettings() async {
        let state = SettingsState(selectedTextSize: .extraLarge, isSubscribed: true)
        let environment = MockSettingsEnvironment()
        
        let result = await settingsMiddleware(state, .saveSettings, environment)
        
        #expect(environment.saveSettingsCalled)
        #expect(environment.saveSettingsCallCount == 1)
        #expect(environment.saveSettingsCalledWith == state)
        #expect(result == .onSavedSettings)
    }
    
    @Test
    func saveSettings_failure_returnsFailedToSaveSettings() async {
        let state = SettingsState()
        let environment = MockSettingsEnvironment()
        environment.saveSettingsError = SettingsTestError("Save failed")
        
        let result = await settingsMiddleware(state, .saveSettings, environment)
        
        #expect(environment.saveSettingsCalled)
        #expect(environment.saveSettingsCalledWith == state)
        #expect(result == .failedToSaveSettings)
    }
    
    @Test(arguments: [
        (TextSize.small, false),
        (TextSize.medium, true),
        (TextSize.large, false),
        (TextSize.extraLarge, true)
    ])
    func saveSettings_withVariousStates(textSize: TextSize, isSubscribed: Bool) async {
        let state = SettingsState(selectedTextSize: textSize, isSubscribed: isSubscribed)
        let environment = MockSettingsEnvironment()
        
        let result = await settingsMiddleware(state, .saveSettings, environment)
        
        #expect(environment.saveSettingsCalled)
        #expect(environment.saveSettingsCalledWith?.selectedTextSize == textSize)
        #expect(environment.saveSettingsCalledWith?.isSubscribed == isSubscribed)
        #expect(result == .onSavedSettings)
    }
    
    // MARK: - No-op Action Tests
    
    @Test(arguments: [
        SettingsAction.onLoadedSettings(SettingsState()),
        SettingsAction.onSavedSettings,
        SettingsAction.failedToLoadSettings,
        SettingsAction.failedToSaveSettings
    ])
    func noOpActions_returnNil(action: SettingsAction) async {
        let state = SettingsState()
        let environment = MockSettingsEnvironment()
        
        let result = await settingsMiddleware(state, action, environment)
        
        #expect(result == nil)
        #expect(!environment.loadSettingsCalled)
        #expect(!environment.saveSettingsCalled)
    }
    
    // MARK: - Integration Flow Tests
    
    @Test
    func fullFlow_selectTextSizeToSave() async {
        let initialState = SettingsState(selectedTextSize: .medium, isSubscribed: false)
        let environment = MockSettingsEnvironment()
        
        // Step 1: Select text size
        let selectResult = await settingsMiddleware(initialState, .selectTextSize(.large), environment)
        #expect(selectResult == .saveSettings)
        
        // Step 2: Save settings (simulating the saveSettings action being dispatched)
        let updatedState = SettingsState(selectedTextSize: .large, isSubscribed: false)
        let saveResult = await settingsMiddleware(updatedState, .saveSettings, environment)
        
        #expect(environment.saveSettingsCalled)
        #expect(environment.saveSettingsCalledWith?.selectedTextSize == .large)
        #expect(saveResult == .onSavedSettings)
    }
    
    // MARK: - Error Handling Tests
    
    @Test
    func loadSettings_multipleFailures() async {
        let state = SettingsState()
        let environment = MockSettingsEnvironment()
        environment.loadSettingsError = SettingsTestError("Persistent error")
        
        // First attempt
        let result1 = await settingsMiddleware(state, .loadSettings, environment)
        #expect(result1 == .failedToLoadSettings)
        #expect(environment.loadSettingsCallCount == 1)
        
        // Second attempt
        let result2 = await settingsMiddleware(state, .loadSettings, environment)
        #expect(result2 == .failedToLoadSettings)
        #expect(environment.loadSettingsCallCount == 2)
    }
    
    @Test
    func saveSettings_multipleFailures() async {
        let state = SettingsState()
        let environment = MockSettingsEnvironment()
        environment.saveSettingsError = SettingsTestError("Persistent save error")
        
        // First attempt
        let result1 = await settingsMiddleware(state, .saveSettings, environment)
        #expect(result1 == .failedToSaveSettings)
        #expect(environment.saveSettingsCallCount == 1)
        
        // Second attempt
        let result2 = await settingsMiddleware(state, .saveSettings, environment)
        #expect(result2 == .failedToSaveSettings)
        #expect(environment.saveSettingsCallCount == 2)
    }
    
    // MARK: - Environment Interaction Tests
    
    @Test
    func middleware_callsEnvironmentSettingsSubject() async {
        let state = SettingsState()
        let environment = MockSettingsEnvironment()
        let loadedSettings = SettingsState(selectedTextSize: .large, isSubscribed: true)
        environment.loadSettingsReturnValue = loadedSettings
        
        let _ = await settingsMiddleware(state, .loadSettings, environment)
        
        // Verify the environment's settingsSubject is updated
        #expect(environment.settingsSubject.value == loadedSettings)
    }
    
    @Test
    func middleware_preservesSettingsSubjectOnSave() async {
        let state = SettingsState(selectedTextSize: .small, isSubscribed: false)
        let environment = MockSettingsEnvironment()
        
        let _ = await settingsMiddleware(state, .saveSettings, environment)
        
        // Verify the environment's settingsSubject is updated with saved state
        #expect(environment.settingsSubject.value == state)
    }
}
