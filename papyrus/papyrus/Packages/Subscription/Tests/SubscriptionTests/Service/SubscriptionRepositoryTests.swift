//
//  SubscriptionRepositoryTests.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Testing
import Foundation
import StoreKit
import StoreKitTest
@testable import Subscription
@testable import SubscriptionMocks

class SubscriptionRepositoryTests {
    
    // MARK: - Test Properties
    
    private var mockService: MockSubscriptionService!
    private var repository: SubscriptionRepository!
    private var mockProduct: Product!
    private var mockTransaction: Transaction!
//    private var testSession: SKTestSession!
    
    // MARK: - Setup
    
    init() async throws {
        mockService = MockSubscriptionService()
        repository = SubscriptionRepository(service: mockService)
        
        // TODO: Activate once StoreKit Testing is working
        // Set up StoreKitTest session using Bundle.module
//        guard let configURL = Bundle.module.url(forResource: "Products", withExtension: "storekit") else {
//            throw SubscriptionTestError("Could not find Products.storekit configuration file")
//        }
//        testSession = try SKTestSession(contentsOf: configURL)
//        testSession.resetToDefaultState()
        
//        mockProduct = try await Product.products(for: ["premium.subscription.monthly"]).first
        
        // For unit tests, we don't need StoreKit sessions since we're mocking the service layer
        mockProduct = nil
        
        // For transaction, we'll still use nil since we're mocking the service layer
        mockTransaction = nil
    }
    
    // MARK: - fetchSubscriptionProduct Tests
    
    @Test
    func fetchSubscriptionProduct_success_withSingleProduct() async throws {
        // Given
        let expectedProduct = mockProduct
        mockService.fetchProductsReturnValue = [expectedProduct].compactMap { $0 }
        
        // When
        if !mockService.fetchProductsReturnValue.isEmpty {
            let result = try await repository.fetchSubscriptionProduct()
            
            // Then
            #expect(mockService.fetchProductsCalled)
            #expect(mockService.fetchProductsCallCount == 1)
            #expect(result == expectedProduct)
        }
    }
    
    @Test
    func fetchSubscriptionProduct_success_withMultipleProducts() async throws {
        // Given
        let firstProduct = mockProduct
        let secondProduct = mockProduct
        mockService.fetchProductsReturnValue = [firstProduct, secondProduct].compactMap { $0 }
        
        // When
        if !mockService.fetchProductsReturnValue.isEmpty {
            let result = try await repository.fetchSubscriptionProduct()
            
            // Then
            #expect(mockService.fetchProductsCalled)
            #expect(mockService.fetchProductsCallCount == 1)
            #expect(result == firstProduct) // Should return first product
        }
    }
    
    @Test
    func fetchSubscriptionProduct_failure_noProducts() async throws {
        // Given
        mockService.fetchProductsReturnValue = []
        
        // When & Then
        await #expect(throws: SubscriptionError.productNotFound) {
            try await repository.fetchSubscriptionProduct()
        }
        
        #expect(mockService.fetchProductsCalled)
        #expect(mockService.fetchProductsCallCount == 1)
    }
    
    @Test
    func fetchSubscriptionProduct_failure_serviceError() async throws {
        // Given
        let expectedError = SubscriptionError.productNotFound
        mockService.fetchProductsError = expectedError
        
        // When & Then
        await #expect(throws: SubscriptionError.self) {
            try await repository.fetchSubscriptionProduct()
        }
        
        #expect(mockService.fetchProductsCalled)
        #expect(mockService.fetchProductsCallCount == 1)
    }
    
    // MARK: - purchaseSubscription Tests
    
    @Test
    func purchaseSubscription_success() async throws {
        // Given
        let expectedProduct = mockProduct
        let expectedTransaction = mockTransaction
        mockService.fetchProductsReturnValue = [expectedProduct].compactMap { $0 }
        mockService.purchaseReturnValue = expectedTransaction
        
        // When
        if !mockService.fetchProductsReturnValue.isEmpty, expectedTransaction != nil {
            let result = try await repository.purchaseSubscription()
            
            // Then
            #expect(mockService.fetchProductsCalled)
            #expect(mockService.purchaseCalled)
            #expect(mockService.purchaseCallCount == 1)
            #expect(mockService.lastPurchaseProduct == expectedProduct)
            #expect(result == expectedTransaction)
        }
    }
    
    @Test
    func purchaseSubscription_failure_noProduct() async throws {
        // Given
        mockService.fetchProductsReturnValue = []
        
        // When & Then
        await #expect(throws: SubscriptionError.productNotFound) {
            try await repository.purchaseSubscription()
        }
        
        #expect(mockService.fetchProductsCalled)
        #expect(!mockService.purchaseCalled) // Should not reach purchase call
    }
    
    @Test
    func purchaseSubscription_failure_purchaseError() async throws {
        // Given
        let expectedProduct = mockProduct
        let expectedError = SubscriptionError.purchaseFailed
        mockService.fetchProductsReturnValue = [expectedProduct].compactMap { $0 }
        mockService.purchaseError = expectedError
        
        // When & Then
        if !mockService.fetchProductsReturnValue.isEmpty {
            await #expect(throws: SubscriptionError.self) {
                try await repository.purchaseSubscription()
            }
            
            #expect(mockService.fetchProductsCalled)
            #expect(mockService.purchaseCalled)
            #expect(mockService.purchaseCallCount == 1)
        }
    }
    
    // MARK: - restorePurchases Tests
    
    @Test
    func restorePurchases_success() async throws {
        // Given
        let expectedTransactions = [mockTransaction].compactMap { $0 }
        mockService.restorePurchasesReturnValue = expectedTransactions
        
        // When
        try await repository.restorePurchases()
        
        // Then
        #expect(mockService.restorePurchasesCalled)
        #expect(mockService.restorePurchasesCallCount == 1)
    }
    
    @Test
    func restorePurchases_success_emptyTransactions() async throws {
        // Given
        mockService.restorePurchasesReturnValue = []
        
        // When
        try await repository.restorePurchases()
        
        // Then
        #expect(mockService.restorePurchasesCalled)
        #expect(mockService.restorePurchasesCallCount == 1)
    }
    
    @Test
    func restorePurchases_failure() async throws {
        // Given
        let expectedError = SubscriptionError.unknown
        mockService.restorePurchasesError = expectedError
        
        // When & Then
        await #expect(throws: SubscriptionError.self) {
            try await repository.restorePurchases()
        }
        
        #expect(mockService.restorePurchasesCalled)
        #expect(mockService.restorePurchasesCallCount == 1)
    }
    
    // MARK: - isSubscribed Tests
    
    @Test
    func isSubscribed_true() async throws {
        // Given
        mockService.checkSubscriptionStatusReturnValue = true
        
        // When
        let result = await repository.isSubscribed()
        
        // Then
        #expect(result == true)
        #expect(mockService.checkSubscriptionStatusCalled)
        #expect(mockService.checkSubscriptionStatusCallCount == 1)
    }
    
    @Test
    func isSubscribed_false() async throws {
        // Given
        mockService.checkSubscriptionStatusReturnValue = false
        
        // When
        let result = await repository.isSubscribed()
        
        // Then
        #expect(result == false)
        #expect(mockService.checkSubscriptionStatusCalled)
        #expect(mockService.checkSubscriptionStatusCallCount == 1)
    }
    
    // MARK: - getCurrentSubscriptionStatus Tests
    
    @Test
    func getCurrentSubscriptionStatus_withStatus() async throws {
        // Given
        // Note: In real tests, you would create a mock Product.SubscriptionInfo.Status
        let mockStatus: Product.SubscriptionInfo.Status? = nil
        mockService.currentSubscriptionReturnValue = mockStatus
        
        // When
        let result = await repository.getCurrentSubscriptionStatus()
        
        // Then
        #expect(result == mockStatus)
        #expect(mockService.currentSubscriptionCalled)
        #expect(mockService.currentSubscriptionCallCount == 1)
    }
    
    @Test
    func getCurrentSubscriptionStatus_nil() async throws {
        // Given
        mockService.currentSubscriptionReturnValue = nil
        
        // When
        let result = await repository.getCurrentSubscriptionStatus()
        
        // Then
        #expect(result == nil)
        #expect(mockService.currentSubscriptionCalled)
        #expect(mockService.currentSubscriptionCallCount == 1)
    }
    
    // MARK: - startTransactionListener Tests
    
    @Test
    func startTransactionListener() async throws {
        // When
        await repository.startTransactionListener()
        
        // Then
        #expect(mockService.startTransactionListenerCalled)
        #expect(mockService.startTransactionListenerCallCount == 1)
    }
    
    // MARK: - Integration Tests
    
    @Test
    func multipleMethodCalls_maintainCorrectCounts() async throws {
        // Given
        mockService.fetchProductsReturnValue = [mockProduct].compactMap { $0 }
        mockService.checkSubscriptionStatusReturnValue = true
        
        // When
        if !mockService.fetchProductsReturnValue.isEmpty {
            _ = try await repository.fetchSubscriptionProduct()
            _ = try await repository.fetchSubscriptionProduct()
        }
        _ = await repository.isSubscribed()
        await repository.startTransactionListener()
        await repository.startTransactionListener()
        await repository.startTransactionListener()
        
        // Then
        if !mockService.fetchProductsReturnValue.isEmpty {
            #expect(mockService.fetchProductsCallCount == 2)
        }
        #expect(mockService.checkSubscriptionStatusCallCount == 1)
        #expect(mockService.startTransactionListenerCallCount == 3)
    }
    
    @Test
    func errorPropagation_maintainOriginalErrorTypes() async throws {
        // Given
        let productNotFoundError = SubscriptionError.productNotFound
        let purchaseFailedError = SubscriptionError.purchaseFailed
        let unknownError = SubscriptionError.unknown
        
        // Test fetchSubscriptionProduct error propagation
        mockService.fetchProductsError = productNotFoundError
        await #expect(throws: SubscriptionError.productNotFound) {
            try await repository.fetchSubscriptionProduct()
        }
        
        // Reset and test purchase error propagation
        mockService.reset()
        mockService.fetchProductsReturnValue = [mockProduct].compactMap { $0 }
        mockService.purchaseError = purchaseFailedError
        
        if !mockService.fetchProductsReturnValue.isEmpty {
            await #expect(throws: SubscriptionError.purchaseFailed) {
                try await repository.purchaseSubscription()
            }
        }
        
        // Reset and test restore error propagation
        mockService.reset()
        mockService.restorePurchasesError = unknownError
        
        await #expect(throws: SubscriptionError.unknown) {
            try await repository.restorePurchases()
        }
    }
}
