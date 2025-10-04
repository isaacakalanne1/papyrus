//
//  SubscriptionMiddleware.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import ReduxKit

@MainActor
public let subscriptionMiddleware: Middleware<SubscriptionState, SubscriptionAction, SubscriptionEnvironmentProtocol> = { state, action, environment in
        
    switch action {
    case .loadProduct:
        do {
            let product = try await environment.fetchSubscriptionProduct()
            return .productLoaded(product)
        } catch {
            return .productLoadFailed(error.localizedDescription)
        }
        
    case .purchaseSubscription:
        do {
            try await environment.purchaseSubscription()
            return .checkSubscriptionStatus
        } catch {
            return .purchaseFailed(error.localizedDescription)
        }
        
    case .restorePurchases:
        do {
            try await environment.restorePurchases()
            return .checkSubscriptionStatus
        } catch {
            return .restoreFailed(error.localizedDescription)
        }
        
    case .checkSubscriptionStatus:
        do {
            let isSubscribed = try await environment.checkSubscriptionStatus()
            let product = try await environment.fetchSubscriptionProduct()
            let status = try await product.subscription?.status.first(where: { status in
                switch status.state {
                case .subscribed, .inBillingRetryPeriod:
                    return true
                default:
                    return false
                }
            })
            return .subscriptionStatusUpdated(isSubscribed: isSubscribed, status: status)
        } catch {
            return .subscriptionStatusUpdated(isSubscribed: false, status: nil)
        }
        
    case .productLoaded,
         .productLoadFailed,
         .purchaseSucceeded,
         .purchaseFailed,
         .restoreSucceeded,
         .restoreFailed,
         .subscriptionStatusUpdated,
         .clearError:
        return nil
    }
}
