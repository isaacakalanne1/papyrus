//
//  SubscriptionSubscriber.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import ReduxKit

@MainActor
let subscriptionSubscriber: OnSubscribe<SubscriptionStore, SubscriptionEnvironmentProtocol> = { _, _ in
    // Handle any state changes that need side effects
}
