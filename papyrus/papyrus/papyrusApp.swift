//
//  papyrusApp.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI
import Reader
import TextGeneration
import Settings
import UIKit

@main
struct papyrusApp: App {
    let environment: ReaderEnvironmentProtocol
    let settingsEnvironment: SettingsEnvironmentProtocol
    
    init() {
        // Create settings environment
        self.settingsEnvironment = SettingsEnvironment()
        
        // Create text generation and reader environments
        let textGenerationEnvironment = TextGenerationEnvironment()
        self.environment = ReaderEnvironment(
            textGenerationEnvironment: textGenerationEnvironment,
            settingsEnvironment: settingsEnvironment
        )
    }

    var body: some Scene {
        WindowGroup {
            ReaderRootView(environment: environment)
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
        }
    }
}
