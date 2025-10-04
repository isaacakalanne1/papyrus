//
//  MockSubscriptionRepository.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import StoreKit
@testable import Subscription

public class MockSubscriptionRepository: SubscriptionRepositoryProtocol {
    
    // MARK: - Spy Properties for Method Calls
    public var fetchSubscriptionProductCalled = false
    public var fetchSubscriptionProductCallCount = 0
    
    public var purchaseSubscriptionCalled = false
    public var purchaseSubscriptionCallCount = 0
    
    public var restorePurchasesCalled = false
    public var restorePurchasesCallCount = 0
    
    public var isSubscribedCalled = false
    public var isSubscribedCallCount = 0
    
    public var getCurrentSubscriptionStatusCalled = false
    public var getCurrentSubscriptionStatusCallCount = 0
    
    public var startTransactionListenerCalled = false
    public var startTransactionListenerCallCount = 0
    
    // MARK: - Return Values and Error Configuration
    public var fetchSubscriptionProductReturnValue: Product?
    public var fetchSubscriptionProductError: Error?
    
    public var purchaseSubscriptionReturnValue: Transaction?
    public var purchaseSubscriptionError: Error?
    
    public var restorePurchasesError: Error?
    
    public var isSubscribedReturnValue: Bool = false
    
    public var getCurrentSubscriptionStatusReturnValue: Product.SubscriptionInfo.Status?
    
    // MARK: - Initialization
    public init() {}
    
    // MARK: - SubscriptionRepositoryProtocol Methods
    
    public func fetchSubscriptionProduct() async throws -> Product {
        fetchSubscriptionProductCalled = true
        fetchSubscriptionProductCallCount += 1
        
        if let error = fetchSubscriptionProductError {
            throw error
        }
        
        guard let product = fetchSubscriptionProductReturnValue else {
            throw SubscriptionTestError("No mock product configured")
        }
        
        return product
    }
    
    public func purchaseSubscription() async throws -> Transaction {
        purchaseSubscriptionCalled = true
        purchaseSubscriptionCallCount += 1
        
        if let error = purchaseSubscriptionError {
            throw error
        }
        
        guard let transaction = purchaseSubscriptionReturnValue else {
            throw SubscriptionTestError("No mock transaction configured")
        }
        
        return transaction
    }
    
    public func restorePurchases() async throws {
        restorePurchasesCalled = true
        restorePurchasesCallCount += 1
        
        if let error = restorePurchasesError {
            throw error
        }
    }
    
    public func isSubscribed() async -> Bool {
        isSubscribedCalled = true
        isSubscribedCallCount += 1
        
        return isSubscribedReturnValue
    }
    
    public func getCurrentSubscriptionStatus() async -> Product.SubscriptionInfo.Status? {
        getCurrentSubscriptionStatusCalled = true
        getCurrentSubscriptionStatusCallCount += 1
        
        return getCurrentSubscriptionStatusReturnValue
    }
    
    public func startTransactionListener() async {
        startTransactionListenerCalled = true
        startTransactionListenerCallCount += 1
    }
    
    // MARK: - Helper Methods
    
    public func reset() {
        fetchSubscriptionProductCalled = false
        fetchSubscriptionProductCallCount = 0
        
        purchaseSubscriptionCalled = false
        purchaseSubscriptionCallCount = 0
        
        restorePurchasesCalled = false
        restorePurchasesCallCount = 0
        
        isSubscribedCalled = false
        isSubscribedCallCount = 0
        
        getCurrentSubscriptionStatusCalled = false
        getCurrentSubscriptionStatusCallCount = 0
        
        startTransactionListenerCalled = false
        startTransactionListenerCallCount = 0
        
        fetchSubscriptionProductReturnValue = nil
        fetchSubscriptionProductError = nil
        purchaseSubscriptionReturnValue = nil
        purchaseSubscriptionError = nil
        restorePurchasesError = nil
        isSubscribedReturnValue = false
        getCurrentSubscriptionStatusReturnValue = nil
    }
}