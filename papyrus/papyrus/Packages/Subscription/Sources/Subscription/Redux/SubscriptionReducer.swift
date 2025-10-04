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
    case .loadProduct:
        newState.isLoading = true
        newState.error = nil
        
    case .productLoaded(let product):
        newState.isLoading = false
        newState.product = product
        newState.error = nil
        
    case .productLoadFailed(let error):
        newState.isLoading = false
        newState.error = error
        
    case .purchaseSubscription:
        newState.isLoading = true
        newState.error = nil
        
    case .purchaseSucceeded:
        newState.isLoading = false
        newState.isSubscribed = true
        newState.error = nil
        
    case .purchaseFailed(let error):
        newState.isLoading = false
        newState.error = error
        
    case .restorePurchases:
        newState.isLoading = true
        newState.error = nil
        
    case .restoreSucceeded:
        newState.isLoading = false
        newState.error = nil
        
    case .restoreFailed(let error):
        newState.isLoading = false
        newState.error = error
        
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
