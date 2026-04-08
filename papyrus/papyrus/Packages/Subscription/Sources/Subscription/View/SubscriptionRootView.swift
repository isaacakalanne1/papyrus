//
//  SubscriptionRootView.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import ReduxKit
import SwiftUI

public struct SubscriptionRootView: View {
    @StateObject private var store: SubscriptionStore
    let fontName: String

    public init(environment: SubscriptionEnvironmentProtocol, fontName: String = "Georgia") {
        _store = StateObject(wrappedValue: Store(
            initial: SubscriptionState(),
            reducer: subscriptionReducer,
            environment: environment,
            middleware: subscriptionMiddleware,
            subscriber: subscriptionSubscriber
        ))
        self.fontName = fontName
    }

    public var body: some View {
        SubscriptionView(fontName: fontName)
            .environmentObject(store)
            .onAppear {
                store.dispatch(.loadProduct)
                store.dispatch(.checkSubscriptionStatus)
            }
    }
}
