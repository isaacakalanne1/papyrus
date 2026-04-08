//
//  SettingsRootView.swift
//  Settings
//
//  Created by Isaac Akalanne on 01/10/2025.
//

import ReduxKit
import SwiftUI

public struct SettingsRootView: View {
    @StateObject private var store: SettingsStore

    public init(environment: SettingsEnvironmentProtocol) {
        _store = StateObject(wrappedValue: Store(
            initial: SettingsState(),
            reducer: settingsReducer,
            environment: environment,
            middleware: settingsMiddleware,
            subscriber: settingsSubscriber
        ))
    }

    public var body: some View {
        SettingsView()
            .environmentObject(store)
            .onAppear {
                store.dispatch(.loadSettings)
            }
    }
}
