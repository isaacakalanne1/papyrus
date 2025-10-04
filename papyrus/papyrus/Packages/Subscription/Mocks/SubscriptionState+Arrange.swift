//
//  SubscriptionState+Arrange.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import StoreKit
import Subscription

public extension SubscriptionState {
    static var arrange: SubscriptionState {
        arrange()
    }
    
    static func arrange(
        isSubscribed: Bool = false,
        isLoading: Bool = false,
        product: Product? = nil,
        error: String? = nil,
        subscriptionStatus: Product.SubscriptionInfo.Status? = nil
    ) -> SubscriptionState {
        .init(
            isSubscribed: isSubscribed,
            isLoading: isLoading,
            product: product,
            error: error,
            subscriptionStatus: subscriptionStatus
        )
    }
}