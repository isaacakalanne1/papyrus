//
//  SettingsSubscriber.swift
//  Settings
//
//  Created by Isaac Akalanne on 01/10/2025.
//

import Combine
import ReduxKit

@MainActor
public let settingsSubscriber: OnSubscribe<SettingsStore, SettingsEnvironmentProtocol> = { _, _ in
}
