//
//  SubscriptionRepository.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import StoreKit
import Foundation

public protocol SubscriptionRepositoryProtocol {
    func fetchSubscriptionProduct() async throws -> Product
    func purchaseSubscription() async throws -> Transaction
    func restorePurchases() async throws
    func isSubscribed() async -> Bool
    func getCurrentSubscriptionStatus() async -> Product.SubscriptionInfo.Status?
    func startTransactionListener() async
}

public class SubscriptionRepository: SubscriptionRepositoryProtocol {
    private let service: SubscriptionServiceProtocol
    
    public init(
        service: SubscriptionServiceProtocol = SubscriptionService()
    ) {
        self.service = service
    }
    
    public func fetchSubscriptionProduct() async throws -> Product {
        let products = try await service.fetchProducts()
        guard let product = products.first else {
            throw SubscriptionError.productNotFound
        }
        return product
    }
    
    public func purchaseSubscription() async throws -> Transaction {
        let product = try await fetchSubscriptionProduct()
        return try await service.purchase(product: product)
    }
    
    public func restorePurchases() async throws {
        _ = try await service.restorePurchases()
    }
    
    public func isSubscribed() async -> Bool {
        return await service.checkSubscriptionStatus()
    }
    
    public func getCurrentSubscriptionStatus() async -> Product.SubscriptionInfo.Status? {
        return await service.currentSubscription()
    }
    
    public func startTransactionListener() async {
        await service.startTransactionListener()
    }
}
