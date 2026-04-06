//
//  SettingsReducerTests.swift
//  Settings
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import Foundation
@testable import Settings

@MainActor
class SettingsReducerTests {
    
    // MARK: - selectTextSize Action Tests
    
    @Test(arguments: [
        TextSize.small,
        TextSize.medium,
        TextSize.large,
        TextSize.extraLarge
    ])
    func selectTextSize_updatesSelectedTextSize(textSize: TextSize) {
        let initialState = SettingsState.arrange(selectedTextSize: .medium, isSubscribed: false)
        
        let newState = settingsReducer(initialState, .selectTextSize(textSize))
        
        var expectedState = initialState
        expectedState.selectedTextSize = textSize
        
        #expect(newState == expectedState)
    }
    
    @Test
    func selectTextSize_preservesOtherProperties() {
        let initialState = SettingsState.arrange(selectedTextSize: .small, isSubscribed: true)
        
        let newState = settingsReducer(initialState, .selectTextSize(.large))
        
        var expectedState = initialState
        expectedState.selectedTextSize = .large
        
        #expect(newState == expectedState)
    }
    
    // MARK: - onLoadedSettings Action Tests
    
    @Test
    func onLoadedSettings_replacesEntireState() {
        let initialState = SettingsState.arrange(selectedTextSize: .small, isSubscribed: false)
        let loadedSettings = SettingsState.arrange(selectedTextSize: .extraLarge, isSubscribed: true)
        
        let newState = settingsReducer(initialState, .onLoadedSettings(loadedSettings))
        
        // onLoadedSettings completely replaces state, so expected = loaded settings
        let expectedState = loadedSettings
        
        #expect(newState == expectedState)
    }
    
    @Test(arguments: [
        (TextSize.small, false),
        (TextSize.medium, true),
        (TextSize.large, false),
        (TextSize.extraLarge, true)
    ])
    func onLoadedSettings_withVariousStates(textSize: TextSize, isSubscribed: Bool) {
        let initialState = SettingsState.arrange
        let loadedSettings = SettingsState.arrange(selectedTextSize: textSize, isSubscribed: isSubscribed)
        
        let newState = settingsReducer(initialState, .onLoadedSettings(loadedSettings))
        
        // onLoadedSettings completely replaces state, so expected = loaded settings
        let expectedState = loadedSettings
        
        #expect(newState == expectedState)
    }
    
    // MARK: - uploadBackgroundImage Tests

    @Test
    func uploadBackgroundImage_setsBackgroundImageData() {
        let initialState = SettingsState.arrange
        let imageData = Data("test-image-data".utf8)

        let newState = settingsReducer(initialState, .uploadBackgroundImage(imageData))

        var expectedState = initialState
        expectedState.backgroundImageData = imageData
        #expect(newState == expectedState)
    }

    @Test
    func uploadBackgroundImage_preservesOtherProperties() {
        let imageData = Data("existing-image".utf8)
        let initialState = SettingsState.arrange(backgroundImageData: imageData, backgroundImageUsage: [.home])
        let newImageData = Data("new-image-data".utf8)

        let newState = settingsReducer(initialState, .uploadBackgroundImage(newImageData))

        #expect(newState.backgroundImageData == newImageData)
        #expect(newState.backgroundImageUsage == [.home])
    }

    // MARK: - setBackgroundImageUsage Tests

    @Test
    func setBackgroundImageUsage_updatesUsage() {
        let initialState = SettingsState.arrange
        let usage: Set<BackgroundImageContext> = [.home, .story]

        let newState = settingsReducer(initialState, .setBackgroundImageUsage(usage))

        var expectedState = initialState
        expectedState.backgroundImageUsage = usage
        #expect(newState == expectedState)
    }

    @Test(arguments: [
        (Set<BackgroundImageContext>([.home])),
        (Set<BackgroundImageContext>([.story])),
        (Set<BackgroundImageContext>([.interactiveStory])),
        (Set<BackgroundImageContext>([.home, .story, .interactiveStory])),
        (Set<BackgroundImageContext>())
    ])
    func setBackgroundImageUsage_withVariousContexts(usage: Set<BackgroundImageContext>) {
        let initialState = SettingsState.arrange

        let newState = settingsReducer(initialState, .setBackgroundImageUsage(usage))

        #expect(newState.backgroundImageUsage == usage)
    }

    // MARK: - confirmDeleteBackgroundImage Tests

    @Test
    func confirmDeleteBackgroundImage_clearsImageDataAndUsage() {
        let imageData = Data("some-image".utf8)
        let initialState = SettingsState.arrange(
            backgroundImageData: imageData,
            backgroundImageUsage: [.home, .story]
        )

        let newState = settingsReducer(initialState, .confirmDeleteBackgroundImage)

        #expect(newState.backgroundImageData == nil)
        #expect(newState.backgroundImageUsage == [])
    }

    @Test
    func confirmDeleteBackgroundImage_whenAlreadyEmpty_remainsEmpty() {
        let initialState = SettingsState.arrange

        let newState = settingsReducer(initialState, .confirmDeleteBackgroundImage)

        #expect(newState.backgroundImageData == nil)
        #expect(newState.backgroundImageUsage == [])
    }

    // MARK: - setSentenceCount Action Tests

    @Test(arguments: [1, 3, 5, 10])
    func setSentenceCount_updatesValue(count: Int) {
        let initialState = SettingsState.arrange

        let newState = settingsReducer(initialState, .setSentenceCount(count))

        var expectedState = initialState
        expectedState.sentenceCount = count
        #expect(newState == expectedState)
    }

    @Test
    func setSentenceCount_preservesOtherProperties() {
        let initialState = SettingsState.arrange(selectedTextSize: .large, isSubscribed: true, sentenceCount: 3)

        let newState = settingsReducer(initialState, .setSentenceCount(7))

        #expect(newState.sentenceCount == 7)
        #expect(newState.selectedTextSize == .large)
        #expect(newState.isSubscribed == true)
    }

    @Test
    func setSentenceCount_boundary_one() {
        let initialState = SettingsState.arrange

        let newState = settingsReducer(initialState, .setSentenceCount(1))

        #expect(newState.sentenceCount == 1)
    }

    @Test
    func setSentenceCount_boundary_ten() {
        let initialState = SettingsState.arrange

        let newState = settingsReducer(initialState, .setSentenceCount(10))

        #expect(newState.sentenceCount == 10)
    }

    // MARK: - No-op Action Tests

    @Test(arguments: [
        SettingsAction.loadSettings,
        SettingsAction.saveSettings,
        SettingsAction.onSavedSettings,
        SettingsAction.failedToLoadSettings,
        SettingsAction.failedToSaveSettings
    ])
    func noOpActions_returnUnchangedState(action: SettingsAction) {
        let initialState = SettingsState.arrange(selectedTextSize: .large, isSubscribed: true)
        
        let newState = settingsReducer(initialState, action)
        
        var expectedState = initialState
        // No changes expected for no-op actions
        
        #expect(newState == expectedState)
    }
    
    // MARK: - State Immutability Tests
    
    @Test
    func reducer_doesNotMutateOriginalState() {
        let originalState = SettingsState.arrange(selectedTextSize: .medium, isSubscribed: false)
        let originalStateSnapshot = originalState
        
        let _ = settingsReducer(originalState, .selectTextSize(.large))
        
        // Original state should remain unchanged
        var expectedOriginalState = originalState
        // No changes expected to original state
        #expect(originalState == expectedOriginalState)
        #expect(originalState == originalStateSnapshot)
    }
    
    @Test
    func reducer_returnsNewStateInstance() {
        let initialState = SettingsState.arrange
        
        let newState = settingsReducer(initialState, .selectTextSize(.large))
        
        var expectedState = initialState
        expectedState.selectedTextSize = .large
        
        #expect(newState == expectedState)
        #expect(newState.selectedTextSize != initialState.selectedTextSize)
    }
    
    // MARK: - Edge Case Tests
    
    @Test
    func selectTextSize_sameSize_stillUpdatesState() {
        let initialState = SettingsState.arrange(selectedTextSize: .medium, isSubscribed: true)
        
        let newState = settingsReducer(initialState, .selectTextSize(.medium))
        
        var expectedState = initialState
        expectedState.selectedTextSize = .medium
        
        #expect(newState == expectedState)
    }
    
    @Test
    func onLoadedSettings_identicalState_replacesState() {
        let initialState = SettingsState.arrange(selectedTextSize: .large, isSubscribed: false)
        let identicalSettings = SettingsState.arrange(selectedTextSize: .large, isSubscribed: false)
        
        let newState = settingsReducer(initialState, .onLoadedSettings(identicalSettings))
        
        // onLoadedSettings completely replaces state, so expected = loaded settings
        let expectedState = identicalSettings
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Default State Tests
    
    @Test
    func reducer_withDefaultState() {
        let defaultState = SettingsState.arrange
        
        var expectedDefaultState = SettingsState.arrange
        // No changes expected to default state
        #expect(defaultState == expectedDefaultState)
        
        let newState = settingsReducer(defaultState, .selectTextSize(.small))
        
        var expectedState = defaultState
        expectedState.selectedTextSize = .small
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Multiple Action Sequence Tests
    
    @Test
    func reducer_multipleActions() {
        var state = SettingsState.arrange
        
        // Apply multiple actions in sequence
        state = settingsReducer(state, .selectTextSize(.large))
        var expectedState = state
        expectedState.selectedTextSize = .large
        #expect(state == expectedState)
        
        // Load new settings
        let loadedSettings = SettingsState.arrange(selectedTextSize: .small, isSubscribed: true)
        state = settingsReducer(state, .onLoadedSettings(loadedSettings))
        expectedState = loadedSettings
        #expect(state == expectedState)
        
        // Change text size again
        state = settingsReducer(state, .selectTextSize(.extraLarge))
        expectedState = state
        expectedState.selectedTextSize = .extraLarge
        #expect(state == expectedState)
        
        // No-op action
        let beforeNoOp = state
        state = settingsReducer(state, .saveSettings)
        expectedState = beforeNoOp
        // No changes expected for no-op actions
        #expect(state == expectedState)
        #expect(state == beforeNoOp)
    }
}