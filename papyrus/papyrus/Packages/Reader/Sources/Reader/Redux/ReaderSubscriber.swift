//
//  ReaderSubscriber.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import Foundation
import ReduxKit
import Combine

@MainActor
let readerSubscriber: OnSubscribe<ReaderStore, ReaderEnvironmentProtocol> = { store, environment in
    environment.settingsEnvironment.settingsSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak store] settings in
                guard let store,
                let settings else {
                    return
                }
                store.dispatch(.refreshSettings(settings))
            }
            .store(in: &store.subscriptions)
}
