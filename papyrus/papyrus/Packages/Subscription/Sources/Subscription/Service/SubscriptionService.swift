//
//  SubscriptionService.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import StoreKit
import Foundation

public enum SubscriptionError: Error {
    case productNotFound
    case purchaseFailed
    case verificationFailed
    case unknown
}

public protocol SubscriptionServiceProtocol {
    func fetchProducts() async throws -> [Product]
    func purchase(product: Product) async throws -> Transaction
    func restorePurchases() async throws -> [Transaction]
    func checkSubscriptionStatus() async -> Bool
    func currentSubscription() async -> Product.SubscriptionInfo.Status?
    func startTransactionListener() async
}

public class SubscriptionService: SubscriptionServiceProtocol {
    private let productId = "com.papyrus.monthly.subscription"
    private var updateListenerTask: Task<Void, Error>?
    
    public init() { }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    public func startTransactionListener() async {
        for await result in Transaction.updates {
            do {
                let transaction = try self.checkVerified(result)
                await transaction.finish()
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }
    }
    
    public func fetchProducts() async throws -> [Product] {
        do {
            let products = try await Product.products(for: [productId])
            guard !products.isEmpty else {
                throw SubscriptionError.productNotFound
            }
            return products
        } catch {
            throw SubscriptionError.productNotFound
        }
    }
    
    public func purchase(product: Product) async throws -> Transaction {
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                return transaction
            case .userCancelled:
                throw SubscriptionError.purchaseFailed
            case .pending:
                throw SubscriptionError.purchaseFailed
            @unknown default:
                throw SubscriptionError.unknown
            }
        } catch {
            throw SubscriptionError.purchaseFailed
        }
    }
    
    public func restorePurchases() async throws -> [Transaction] {
        var restoredTransactions: [Transaction] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                restoredTransactions.append(transaction)
                await transaction.finish()
            } catch {
                print("Transaction verification failed: \(error)")
            }
        }
        
        return restoredTransactions
    }
    
    public func checkSubscriptionStatus() async -> Bool {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.productID == productId {
                    return true
                }
            } catch {
                return false
            }
        }
        return false
    }
    
    public func currentSubscription() async -> Product.SubscriptionInfo.Status? {
        do {
            let products = try await fetchProducts()
            guard let product = products.first else { return nil }
            
            let statuses = try await product.subscription?.status ?? []
            
            for status in statuses {
                switch status.state {
                case .subscribed, .inBillingRetryPeriod:
                    return status
                default:
                    continue
                }
            }
        } catch {
            return nil
        }
        
        return nil
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw SubscriptionError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }
}
