//
//  SubscriptionEnvironmentTests.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import StoreKit
import Settings
import SettingsMocks
@testable import Subscription
@testable import SubscriptionMocks

class SubscriptionEnvironmentTests {
    
    // MARK: - Test Properties
    
    private var mockRepository: MockSubscriptionRepository!
    private var mockSettingsEnvironment: MockSettingsEnvironment!
    private var subscriptionEnvironment: SubscriptionEnvironment!
    
    // MARK: - Setup
    
    init() async throws {
        mockRepository = MockSubscriptionRepository()
        mockSettingsEnvironment = MockSettingsEnvironment()
        subscriptionEnvironment = SubscriptionEnvironment(
            repository: mockRepository,
            settingsEnvironment: mockSettingsEnvironment
        )
    }
    
    // MARK: - fetchSubscriptionProduct Tests
    
    @Test
    func fetchSubscriptionProduct_failure() async throws {
        // Given
        let expectedError = SubscriptionError.productNotFound
        mockRepository.fetchSubscriptionProductError = expectedError
        
        // When & Then
        await #expect(throws: SubscriptionError.self) {
            try await subscriptionEnvironment.fetchSubscriptionProduct()
        }
        
        #expect(mockRepository.fetchSubscriptionProductCalled)
        #expect(mockRepository.fetchSubscriptionProductCallCount == 1)
    }
    
    @Test
    func purchaseSubscription_failure() async throws {
        // Given
        let expectedError = SubscriptionError.purchaseFailed
        mockRepository.purchaseSubscriptionError = expectedError
        
        // When & Then
        await #expect(throws: SubscriptionError.self) {
            try await subscriptionEnvironment.purchaseSubscription()
        }
        
        #expect(mockRepository.purchaseSubscriptionCalled)
        #expect(mockRepository.purchaseSubscriptionCallCount == 1)
        // Settings should not be updated on purchase failure
        #expect(!mockSettingsEnvironment.saveSettingsCalled)
    }
    
    // MARK: - restorePurchases Tests
    
    @Test
    func restorePurchases_success() async throws {
        // Given
        let mockSettings = SettingsState()
        mockRepository.isSubscribedReturnValue = true
        mockSettingsEnvironment.loadSettingsReturnValue = mockSettings
        
        // When
        try await subscriptionEnvironment.restorePurchases()
        
        // Then
        #expect(mockRepository.restorePurchasesCalled)
        #expect(mockRepository.restorePurchasesCallCount == 1)
        #expect(mockRepository.isSubscribedCalled)
        #expect(mockSettingsEnvironment.loadSettingsCalled)
        #expect(mockSettingsEnvironment.saveSettingsCalled)
    }
    
    @Test
    func restorePurchases_failure() async throws {
        // Given
        let expectedError = SubscriptionError.unknown
        mockRepository.restorePurchasesError = expectedError
        
        // When & Then
        await #expect(throws: SubscriptionError.self) {
            try await subscriptionEnvironment.restorePurchases()
        }
        
        #expect(mockRepository.restorePurchasesCalled)
        #expect(mockRepository.restorePurchasesCallCount == 1)
        // Settings should not be updated on restore failure
        #expect(!mockSettingsEnvironment.saveSettingsCalled)
    }
    
    // MARK: - checkSubscriptionStatus Tests
    
    @Test
    func checkSubscriptionStatus_subscribed() async throws {
        // Given
        let mockSettings = SettingsState()
        mockRepository.isSubscribedReturnValue = true
        mockSettingsEnvironment.loadSettingsReturnValue = mockSettings
        
        // When
        let result = try await subscriptionEnvironment.checkSubscriptionStatus()
        
        // Then
        #expect(result == true)
        #expect(mockRepository.isSubscribedCalled)
        #expect(mockRepository.isSubscribedCallCount >= 1) // Called multiple times for status update
        #expect(mockSettingsEnvironment.loadSettingsCalled)
        #expect(mockSettingsEnvironment.saveSettingsCalled)
    }
    
    @Test
    func checkSubscriptionStatus_notSubscribed() async throws {
        // Given
        let mockSettings = SettingsState()
        mockRepository.isSubscribedReturnValue = false
        mockSettingsEnvironment.loadSettingsReturnValue = mockSettings
        
        // When
        let result = try await subscriptionEnvironment.checkSubscriptionStatus()
        
        // Then
        #expect(result == false)
        #expect(mockRepository.isSubscribedCalled)
        #expect(mockSettingsEnvironment.loadSettingsCalled)
        #expect(mockSettingsEnvironment.saveSettingsCalled)
    }
    
    @Test
    func checkSubscriptionStatus_settingsUpdateFailure() async throws {
        // Given
        mockRepository.isSubscribedReturnValue = true
        mockSettingsEnvironment.loadSettingsError = SettingsTestError("Settings load failed")
        
        // When
        let result = try await subscriptionEnvironment.checkSubscriptionStatus()
        
        // Then
        #expect(result == true)
        #expect(mockRepository.isSubscribedCalled)
        #expect(mockSettingsEnvironment.loadSettingsCalled)
        // Save should not be called if load fails
        #expect(!mockSettingsEnvironment.saveSettingsCalled)
    }
    
    // MARK: - loadSubscriptionOnInit Tests
    
    @Test
    func loadSubscriptionOnInit() async throws {
        // Given
        let mockSettings = SettingsState()
        mockRepository.isSubscribedReturnValue = true
        mockSettingsEnvironment.loadSettingsReturnValue = mockSettings
        
        // When
        await subscriptionEnvironment.loadSubscriptionOnInit()
        
        // Then
        #expect(mockRepository.isSubscribedCalled)
        #expect(mockRepository.startTransactionListenerCalled)
        #expect(mockSettingsEnvironment.loadSettingsCalled)
        #expect(mockSettingsEnvironment.saveSettingsCalled)
    }
    
    // MARK: - startTransactionListener Tests
    
    @Test
    func startTransactionListener() async throws {
        // When
        await subscriptionEnvironment.startTransactionListener()
        
        // Then
        #expect(mockRepository.startTransactionListenerCalled)
        #expect(mockRepository.startTransactionListenerCallCount == 1)
    }
    
    // MARK: - Integration Tests
    
    @Test
    func updateSubscriptionStatusInSettings_success() async throws {
        // Given
        var mockSettings = SettingsState()
        mockSettings.isSubscribed = false
        mockRepository.isSubscribedReturnValue = true
        mockSettingsEnvironment.loadSettingsReturnValue = mockSettings
        
        // When
        _ = try await subscriptionEnvironment.checkSubscriptionStatus()
        
        // Then
        #expect(mockSettingsEnvironment.saveSettingsCalled)
        #expect(mockSettingsEnvironment.saveSettingsCallCount == 1)
        
        // Verify the settings passed to save have updated subscription status
        if let savedSettings = mockSettingsEnvironment.saveSettingsCalledWith {
            #expect(savedSettings.isSubscribed == true)
        }
    }
    
    @Test
    func updateSubscriptionStatusInSettings_loadFailure() async throws {
        // Given
        mockRepository.isSubscribedReturnValue = true
        mockSettingsEnvironment.loadSettingsError = SettingsTestError("Load failed")
        
        // When
        let result = try await subscriptionEnvironment.checkSubscriptionStatus()
        
        // Then
        #expect(result == true)
        #expect(mockSettingsEnvironment.loadSettingsCalled)
        #expect(!mockSettingsEnvironment.saveSettingsCalled)
    }
    
    @Test
    func updateSubscriptionStatusInSettings_saveFailure() async throws {
        // Given
        let mockSettings = SettingsState()
        mockRepository.isSubscribedReturnValue = true
        mockSettingsEnvironment.loadSettingsReturnValue = mockSettings
        mockSettingsEnvironment.saveSettingsError = SettingsTestError("Save failed")
        
        // When
        let result = try await subscriptionEnvironment.checkSubscriptionStatus()
        
        // Then
        #expect(result == true)
        #expect(mockSettingsEnvironment.loadSettingsCalled)
        #expect(mockSettingsEnvironment.saveSettingsCalled)
        // Should not throw error despite save failure (error is printed)
    }
}
