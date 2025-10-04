//
//  MockSubscriptionService.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import StoreKit
@testable import Subscription

public class MockSubscriptionService: SubscriptionServiceProtocol {
    
    // MARK: - Spy Properties for Method Calls
    public var fetchProductsCalled = false
    public var fetchProductsCallCount = 0
    
    public var purchaseCalled = false
    public var purchaseCallCount = 0
    public var lastPurchaseProduct: Product?
    
    public var restorePurchasesCalled = false
    public var restorePurchasesCallCount = 0
    
    public var checkSubscriptionStatusCalled = false
    public var checkSubscriptionStatusCallCount = 0
    
    public var currentSubscriptionCalled = false
    public var currentSubscriptionCallCount = 0
    
    public var startTransactionListenerCalled = false
    public var startTransactionListenerCallCount = 0
    
    // MARK: - Return Values and Error Configuration
    public var fetchProductsReturnValue: [Product] = []
    public var fetchProductsError: Error?
    
    public var purchaseReturnValue: Transaction?
    public var purchaseError: Error?
    
    public var restorePurchasesReturnValue: [Transaction] = []
    public var restorePurchasesError: Error?
    
    public var checkSubscriptionStatusReturnValue: Bool = false
    
    public var currentSubscriptionReturnValue: Product.SubscriptionInfo.Status?
    
    // MARK: - Initialization
    public init() {}
    
    // MARK: - SubscriptionServiceProtocol Methods
    
    public func fetchProducts() async throws -> [Product] {
        fetchProductsCalled = true
        fetchProductsCallCount += 1
        
        if let error = fetchProductsError {
            throw error
        }
        
        return fetchProductsReturnValue
    }
    
    public func purchase(product: Product) async throws -> Transaction {
        purchaseCalled = true
        purchaseCallCount += 1
        lastPurchaseProduct = product
        
        if let error = purchaseError {
            throw error
        }
        
        guard let transaction = purchaseReturnValue else {
            throw SubscriptionTestError("No mock transaction configured")
        }
        
        return transaction
    }
    
    public func restorePurchases() async throws -> [Transaction] {
        restorePurchasesCalled = true
        restorePurchasesCallCount += 1
        
        if let error = restorePurchasesError {
            throw error
        }
        
        return restorePurchasesReturnValue
    }
    
    public func checkSubscriptionStatus() async -> Bool {
        checkSubscriptionStatusCalled = true
        checkSubscriptionStatusCallCount += 1
        
        return checkSubscriptionStatusReturnValue
    }
    
    public func currentSubscription() async -> Product.SubscriptionInfo.Status? {
        currentSubscriptionCalled = true
        currentSubscriptionCallCount += 1
        
        return currentSubscriptionReturnValue
    }
    
    public func startTransactionListener() async {
        startTransactionListenerCalled = true
        startTransactionListenerCallCount += 1
    }
    
    // MARK: - Helper Methods
    
    public func reset() {
        fetchProductsCalled = false
        fetchProductsCallCount = 0
        
        purchaseCalled = false
        purchaseCallCount = 0
        lastPurchaseProduct = nil
        
        restorePurchasesCalled = false
        restorePurchasesCallCount = 0
        
        checkSubscriptionStatusCalled = false
        checkSubscriptionStatusCallCount = 0
        
        currentSubscriptionCalled = false
        currentSubscriptionCallCount = 0
        
        startTransactionListenerCalled = false
        startTransactionListenerCallCount = 0
        
        fetchProductsReturnValue = []
        fetchProductsError = nil
        purchaseReturnValue = nil
        purchaseError = nil
        restorePurchasesReturnValue = []
        restorePurchasesError = nil
        checkSubscriptionStatusReturnValue = false
        currentSubscriptionReturnValue = nil
    }
}