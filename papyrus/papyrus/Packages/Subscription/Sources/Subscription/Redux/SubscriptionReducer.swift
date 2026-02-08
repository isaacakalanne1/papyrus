//
//  SubscriptionReducer.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import ReduxKit

@MainActor
public let subscriptionReducer: Reducer<SubscriptionState, SubscriptionAction> = { state, action in
    var newState = state
    
    switch action {
    case .loadProduct,
            .purchaseSubscription,
            .restorePurchases:
        newState.isLoading = true
        newState.error = nil
        
    case .productLoaded(let product):
        newState.isLoading = false
        newState.product = product
        newState.error = nil
        
    case .productLoadFailed(let error),
            .purchaseFailed(let error),
            .restoreFailed(let error):
        newState.isLoading = false
        newState.error = error
        
    case .purchaseSucceeded:
        newState.isLoading = false
        newState.isSubscribed = true
        newState.error = nil
        
    case .restoreSucceeded:
        newState.isLoading = false
        newState.error = nil
        
    case .checkSubscriptionStatus:
        newState.isLoading = true
        
    case .subscriptionStatusUpdated(let isSubscribed, let status):
        newState.isLoading = false
        newState.isSubscribed = isSubscribed
        newState.subscriptionStatus = status
        
    case .clearError:
        newState.error = nil
    }
    
    return newState
}
