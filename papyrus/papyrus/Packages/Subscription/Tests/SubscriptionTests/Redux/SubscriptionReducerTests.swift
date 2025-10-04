//
//  SubscriptionReducerTests.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import StoreKit
@testable import Subscription
@testable import SubscriptionMocks

class SubscriptionReducerTests {
    
    // MARK: - Product Loading Tests
    
    @Test
    func loadProduct() {
        let initialState = SubscriptionState.arrange(isLoading: false, error: "Previous error")
        
        let newState = subscriptionReducer(initialState, .loadProduct)
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.error = nil
        
        #expect(newState == expectedState)
    }
    
    // Note: productLoaded test is omitted because Product cannot be initialized in unit tests
    // This would need to be tested in integration tests with real StoreKit products
    
    @Test
    func productLoadFailed() {
        let errorMessage = "Failed to load product"
        let initialState = SubscriptionState.arrange(isLoading: true)
        
        let newState = subscriptionReducer(initialState, .productLoadFailed(errorMessage))
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.error = errorMessage
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Purchase Tests
    
    @Test
    func purchaseSubscription() {
        let initialState = SubscriptionState.arrange(isLoading: false, error: "Previous error")
        
        let newState = subscriptionReducer(initialState, .purchaseSubscription)
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.error = nil
        
        #expect(newState == expectedState)
    }
    
    @Test
    func purchaseSucceeded() {
        let initialState = SubscriptionState.arrange(
            isSubscribed: false,
            isLoading: true,
            error: "Purchase error"
        )
        
        let newState = subscriptionReducer(initialState, .purchaseSucceeded)
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.isSubscribed = true
        expectedState.error = nil
        
        #expect(newState == expectedState)
    }
    
    @Test
    func purchaseFailed() {
        let errorMessage = "Purchase failed"
        let initialState = SubscriptionState.arrange(isLoading: true)
        
        let newState = subscriptionReducer(initialState, .purchaseFailed(errorMessage))
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.error = errorMessage
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Restore Purchases Tests
    
    @Test
    func restorePurchases() {
        let initialState = SubscriptionState.arrange(isLoading: false, error: "Previous error")
        
        let newState = subscriptionReducer(initialState, .restorePurchases)
        
        var expectedState = initialState
        expectedState.isLoading = true
        expectedState.error = nil
        
        #expect(newState == expectedState)
    }
    
    @Test
    func restoreSucceeded() {
        let initialState = SubscriptionState.arrange(isLoading: true, error: "Restore error")
        
        let newState = subscriptionReducer(initialState, .restoreSucceeded)
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.error = nil
        
        #expect(newState == expectedState)
    }
    
    @Test
    func restoreFailed() {
        let errorMessage = "Restore failed"
        let initialState = SubscriptionState.arrange(isLoading: true)
        
        let newState = subscriptionReducer(initialState, .restoreFailed(errorMessage))
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.error = errorMessage
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Subscription Status Tests
    
    @Test
    func checkSubscriptionStatus() {
        let initialState = SubscriptionState.arrange(isLoading: false)
        
        let newState = subscriptionReducer(initialState, .checkSubscriptionStatus)
        
        var expectedState = initialState
        expectedState.isLoading = true
        
        #expect(newState == expectedState)
    }
    
    @Test
    func subscriptionStatusUpdated_subscribed() {
        let initialState = SubscriptionState.arrange(
            isSubscribed: false,
            isLoading: true
        )
        
        let newState = subscriptionReducer(
            initialState, 
            .subscriptionStatusUpdated(isSubscribed: true, status: nil)
        )
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.isSubscribed = true
        expectedState.subscriptionStatus = nil
        
        #expect(newState == expectedState)
    }
    
    @Test
    func subscriptionStatusUpdated_notSubscribed() {
        let initialState = SubscriptionState.arrange(
            isSubscribed: true,
            isLoading: true
        )
        
        let newState = subscriptionReducer(
            initialState, 
            .subscriptionStatusUpdated(isSubscribed: false, status: nil)
        )
        
        var expectedState = initialState
        expectedState.isLoading = false
        expectedState.isSubscribed = false
        expectedState.subscriptionStatus = nil
        
        #expect(newState == expectedState)
    }
    
    // MARK: - Error Handling Tests
    
    @Test
    func clearError() {
        let initialState = SubscriptionState.arrange(error: "Some error")
        
        let newState = subscriptionReducer(initialState, .clearError)
        
        var expectedState = initialState
        expectedState.error = nil
        
        #expect(newState == expectedState)
    }
    
    @Test
    func clearError_noError() {
        let initialState = SubscriptionState.arrange(error: nil)
        
        let newState = subscriptionReducer(initialState, .clearError)
        
        var expectedState = initialState
        // No change expected when there's no error
        
        #expect(newState == expectedState)
    }
}