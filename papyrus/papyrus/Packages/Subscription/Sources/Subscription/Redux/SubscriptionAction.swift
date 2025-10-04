//
//  SubscriptionAction.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import StoreKit

public enum SubscriptionAction: Equatable, Sendable {
    case loadProduct
    case productLoaded(Product)
    case productLoadFailed(String)
    case purchaseSubscription
    case purchaseSucceeded
    case purchaseFailed(String)
    case restorePurchases
    case restoreSucceeded
    case restoreFailed(String)
    case checkSubscriptionStatus
    case subscriptionStatusUpdated(isSubscribed: Bool, status: Product.SubscriptionInfo.Status?)
    case clearError
}
