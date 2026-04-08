//
//  ReaderRootView.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import ReduxKit
import SwiftUI

public struct ReaderRootView: View {
    @StateObject private var store: ReaderStore

    public init(environment: ReaderEnvironmentProtocol) {
        _store = StateObject(wrappedValue: Store(
            initial: ReaderState(),
            reducer: readerReducer,
            environment: environment,
            middleware: readerMiddleware,
            subscriber: readerSubscriber
        ))
    }

    public var body: some View {
        ReaderView()
            .environmentObject(store)
    }
}
