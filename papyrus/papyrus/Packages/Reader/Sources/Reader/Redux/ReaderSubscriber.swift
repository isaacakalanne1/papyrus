//
//  ReaderSubscriber.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import ReduxKit
import Combine

@MainActor
let readerSubscriber: OnSubscribe<ReaderStore, ReaderEnvironmentProtocol> = { store, environment in
    // Subscribe to settings changes
    let _ = environment.settingsEnvironment.settingsSubject
        .compactMap { $0 }
        .sink { settingsState in
            store.dispatch(.refreshSettings(settingsState))
        }
}
