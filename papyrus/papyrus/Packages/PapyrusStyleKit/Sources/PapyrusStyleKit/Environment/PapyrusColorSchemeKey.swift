//
//  PapyrusColorSchemeKey.swift
//  PapyrusStyleKit
//

import SwiftUI

struct PapyrusColorSchemeKey: EnvironmentKey {
    static let defaultValue: PapyrusColorScheme = .parchment
}

public extension EnvironmentValues {
    var papyrusColorScheme: PapyrusColorScheme {
        get { self[PapyrusColorSchemeKey.self] }
        set { self[PapyrusColorSchemeKey.self] = newValue }
    }
}
