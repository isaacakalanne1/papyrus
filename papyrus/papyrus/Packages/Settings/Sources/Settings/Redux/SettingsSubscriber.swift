//
//  SettingsSubscriber.swift
//  Settings
//
//  Created by Isaac Akalanne on 01/10/2025.
//

import ReduxKit
import Combine

@MainActor
public let settingsSubscriber: OnSubscribe<SettingsStore, SettingsEnvironmentProtocol> = { store, environment in
}