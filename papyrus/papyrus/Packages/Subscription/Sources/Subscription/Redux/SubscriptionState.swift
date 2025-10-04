//
//  SubscriptionState.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import StoreKit

public struct SubscriptionState: Equatable {
    public var isSubscribed: Bool
    public var isLoading: Bool
    public var product: Product?
    public var error: String?
    public var subscriptionStatus: Product.SubscriptionInfo.Status?
    
    public init(
        isSubscribed: Bool = false,
        isLoading: Bool = false,
        product: Product? = nil,
        error: String? = nil,
        subscriptionStatus: Product.SubscriptionInfo.Status? = nil
    ) {
        self.isSubscribed = isSubscribed
        self.isLoading = isLoading
        self.product = product
        self.error = error
        self.subscriptionStatus = subscriptionStatus
    }
}