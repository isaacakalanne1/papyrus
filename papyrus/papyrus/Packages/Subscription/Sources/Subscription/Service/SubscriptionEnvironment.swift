//
//  SubscriptionEnvironment.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import StoreKit
import Combine
import Settings

public protocol SubscriptionEnvironmentProtocol {
    func fetchSubscriptionProduct() async throws -> Product
    func purchaseSubscription() async throws
    func restorePurchases() async throws
    func checkSubscriptionStatus() async throws -> Bool
    func loadSubscriptionOnInit() async
    func startTransactionListener() async
}

public class SubscriptionEnvironment: SubscriptionEnvironmentProtocol {
    private let repository: SubscriptionRepositoryProtocol
    private let settingsEnvironment: SettingsEnvironmentProtocol
    
    public init(
        repository: SubscriptionRepositoryProtocol = SubscriptionRepository(),
        settingsEnvironment: SettingsEnvironmentProtocol
    ) {
        self.repository = repository
        self.settingsEnvironment = settingsEnvironment
    }
    
    public func fetchSubscriptionProduct() async throws -> Product {
        return try await repository.fetchSubscriptionProduct()
    }
    
    public func purchaseSubscription() async throws {
        _ = try await repository.purchaseSubscription()
        await updateSubscriptionStatusInSettings()
    }
    
    public func restorePurchases() async throws {
        try await repository.restorePurchases()
        await updateSubscriptionStatusInSettings()
    }
    
    public func checkSubscriptionStatus() async throws -> Bool {
        let isSubscribed = await repository.isSubscribed()
        await updateSubscriptionStatusInSettings()
        return isSubscribed
    }
    
    public func loadSubscriptionOnInit() async {
        await updateSubscriptionStatusInSettings()
        await startTransactionListener()
    }
    
    public func startTransactionListener() async {
        await repository.startTransactionListener()
    }
    
    private func updateSubscriptionStatusInSettings() async {
        do {
            let isSubscribed = await repository.isSubscribed()
            var settings = try await settingsEnvironment.loadSettings()
            settings.isSubscribed = isSubscribed
            try await settingsEnvironment.saveSettings(settings)
        } catch {
            print("Failed to update subscription status in settings: \(error)")
        }
    }
}