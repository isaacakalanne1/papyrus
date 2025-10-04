//
//  SubscriptionMiddlewareTests.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import StoreKit
@testable import Subscription
@testable import SubscriptionMocks

@MainActor
class SubscriptionMiddlewareTests {
    
    // MARK: - Product Loading Tests
    
    // Note: loadProduct success test is omitted because Product cannot be initialized in unit tests
    // This would need to be tested in integration tests with real StoreKit products
    
    @Test
    func loadProduct_failure_returnsProductLoadFailed() async {
        let state = SubscriptionState.arrange
        let environment = MockSubscriptionEnvironment()
        let error = SubscriptionTestError("Fetch failed")
        environment.fetchSubscriptionProductError = error
        
        let result = await subscriptionMiddleware(state, .loadProduct, environment)
        
        #expect(environment.fetchSubscriptionProductCalled)
        #expect(result == .productLoadFailed(error.localizedDescription))
    }
    
    // MARK: - Purchase Tests
    
    @Test
    func purchaseSubscription_success_returnsCheckSubscriptionStatus() async {
        let state = SubscriptionState.arrange
        let environment = MockSubscriptionEnvironment()
        
        let result = await subscriptionMiddleware(state, .purchaseSubscription, environment)
        
        #expect(environment.purchaseSubscriptionCalled)
        #expect(result == .checkSubscriptionStatus)
    }
    
    @Test
    func purchaseSubscription_failure_returnsPurchaseFailed() async {
        let state = SubscriptionState.arrange
        let environment = MockSubscriptionEnvironment()
        let error = SubscriptionTestError("Purchase failed")
        environment.purchaseSubscriptionError = error
        
        let result = await subscriptionMiddleware(state, .purchaseSubscription, environment)
        
        #expect(environment.purchaseSubscriptionCalled)
        #expect(result == .purchaseFailed(error.localizedDescription))
    }
    
    // MARK: - Restore Purchases Tests
    
    @Test
    func restorePurchases_success_returnsCheckSubscriptionStatus() async {
        let state = SubscriptionState.arrange
        let environment = MockSubscriptionEnvironment()
        
        let result = await subscriptionMiddleware(state, .restorePurchases, environment)
        
        #expect(environment.restorePurchasesCalled)
        #expect(result == .checkSubscriptionStatus)
    }
    
    @Test
    func restorePurchases_failure_returnsRestoreFailed() async {
        let state = SubscriptionState.arrange
        let environment = MockSubscriptionEnvironment()
        let error = SubscriptionTestError("Restore failed")
        environment.restorePurchasesError = error
        
        let result = await subscriptionMiddleware(state, .restorePurchases, environment)
        
        #expect(environment.restorePurchasesCalled)
        #expect(result == .restoreFailed(error.localizedDescription))
    }
    
    // MARK: - Check Subscription Status Tests
    
    // Note: checkSubscriptionStatus success tests are omitted because Product cannot be initialized in unit tests
    // These would need to be tested in integration tests with real StoreKit products
    
    @Test
    func checkSubscriptionStatus_checkFailure_returnsStatusUpdatedFalse() async {
        let state = SubscriptionState.arrange
        let environment = MockSubscriptionEnvironment()
        environment.checkSubscriptionStatusError = SubscriptionTestError("Check failed")
        
        let result = await subscriptionMiddleware(state, .checkSubscriptionStatus, environment)
        
        #expect(environment.checkSubscriptionStatusCalled)
        #expect(result == .subscriptionStatusUpdated(isSubscribed: false, status: nil))
    }
    
    @Test
    func checkSubscriptionStatus_fetchProductFailure_returnsStatusUpdatedFalse() async {
        let state = SubscriptionState.arrange
        let environment = MockSubscriptionEnvironment()
        environment.checkSubscriptionStatusReturnValue = true
        environment.fetchSubscriptionProductError = SubscriptionTestError("Fetch failed")
        
        let result = await subscriptionMiddleware(state, .checkSubscriptionStatus, environment)
        
        #expect(environment.checkSubscriptionStatusCalled)
        #expect(environment.fetchSubscriptionProductCalled)
        #expect(result == .subscriptionStatusUpdated(isSubscribed: false, status: nil))
    }
    
    // MARK: - No-op Actions Tests
    
    @Test
    func noOpActions_returnNil() async {
        let state = SubscriptionState.arrange
        let environment = MockSubscriptionEnvironment()
        
        let noOpActions: [SubscriptionAction] = [
            .productLoadFailed("Error"),
            .purchaseSucceeded,
            .purchaseFailed("Error"),
            .restoreSucceeded,
            .restoreFailed("Error"),
            .subscriptionStatusUpdated(isSubscribed: true, status: nil),
            .clearError
        ]
        // Note: .productLoaded(Product()) is omitted because Product cannot be initialized in unit tests
        
        for action in noOpActions {
            let result = await subscriptionMiddleware(state, action, environment)
            #expect(result == nil)
        }
    }
}
