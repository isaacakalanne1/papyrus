//
//  MockSubscriptionEnvironment.swift
//  Subscription
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Foundation
import StoreKit
@testable import Subscription

public class MockSubscriptionEnvironment: SubscriptionEnvironmentProtocol {
    
    // MARK: - Spy Properties for Method Calls
    public var fetchSubscriptionProductCalled = false
    public var fetchSubscriptionProductCallCount = 0
    
    public var purchaseSubscriptionCalled = false
    public var purchaseSubscriptionCallCount = 0
    
    public var restorePurchasesCalled = false
    public var restorePurchasesCallCount = 0
    
    public var checkSubscriptionStatusCalled = false
    public var checkSubscriptionStatusCallCount = 0
    
    public var loadSubscriptionOnInitCalled = false
    public var loadSubscriptionOnInitCallCount = 0
    
    public var startTransactionListenerCalled = false
    public var startTransactionListenerCallCount = 0
    
    // MARK: - Return Values and Error Configuration
    public var fetchSubscriptionProductReturnValue: Product?
    public var fetchSubscriptionProductError: Error?
    
    public var purchaseSubscriptionError: Error?
    
    public var restorePurchasesError: Error?
    
    public var checkSubscriptionStatusReturnValue: Bool = false
    public var checkSubscriptionStatusError: Error?
    
    // MARK: - Initialization
    public init() {}
    
    // MARK: - SubscriptionEnvironmentProtocol Methods
    
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
    
    public func purchaseSubscription() async throws {
        purchaseSubscriptionCalled = true
        purchaseSubscriptionCallCount += 1
        
        if let error = purchaseSubscriptionError {
            throw error
        }
    }
    
    public func restorePurchases() async throws {
        restorePurchasesCalled = true
        restorePurchasesCallCount += 1
        
        if let error = restorePurchasesError {
            throw error
        }
    }
    
    public func checkSubscriptionStatus() async throws -> Bool {
        checkSubscriptionStatusCalled = true
        checkSubscriptionStatusCallCount += 1
        
        if let error = checkSubscriptionStatusError {
            throw error
        }
        
        return checkSubscriptionStatusReturnValue
    }
    
    public func loadSubscriptionOnInit() async {
        loadSubscriptionOnInitCalled = true
        loadSubscriptionOnInitCallCount += 1
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
        
        checkSubscriptionStatusCalled = false
        checkSubscriptionStatusCallCount = 0
        
        loadSubscriptionOnInitCalled = false
        loadSubscriptionOnInitCallCount = 0
        
        startTransactionListenerCalled = false
        startTransactionListenerCallCount = 0
        
        fetchSubscriptionProductReturnValue = nil
        fetchSubscriptionProductError = nil
        purchaseSubscriptionError = nil
        restorePurchasesError = nil
        checkSubscriptionStatusReturnValue = false
        checkSubscriptionStatusError = nil
    }
}

// MARK: - Test Error

public struct SubscriptionTestError: Error, Equatable {
    public let message: String
    
    public init(_ message: String = "Subscription test error") {
        self.message = message
    }
}
