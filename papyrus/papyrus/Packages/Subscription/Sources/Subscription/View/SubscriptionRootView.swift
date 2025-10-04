//
//  SubscriptionRootView.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import ReduxKit

public struct SubscriptionRootView: View {
    @StateObject private var store: SubscriptionStore
    
    public init(environment: SubscriptionEnvironmentProtocol) {
        self._store = StateObject(wrappedValue: {
            Store(
                initial: SubscriptionState(),
                reducer: subscriptionReducer,
                environment: environment,
                middleware: subscriptionMiddleware,
                subscriber: subscriptionSubscriber
            )
        }())
    }
    
    public var body: some View {
        SubscriptionView()
            .environmentObject(store)
            .onAppear {
                store.dispatch(.loadProduct)
                store.dispatch(.checkSubscriptionStatus)
            }
    }
}
