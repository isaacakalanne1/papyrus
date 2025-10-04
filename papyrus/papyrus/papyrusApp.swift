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
import Subscription
import UIKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct papyrusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    let environment: ReaderEnvironmentProtocol
    let settingsEnvironment: SettingsEnvironmentProtocol
    let subscriptionEnvironment: SubscriptionEnvironmentProtocol
    
    init() {
        // Create settings environment
        self.settingsEnvironment = SettingsEnvironment()
        
        // Create subscription environment
        self.subscriptionEnvironment = SubscriptionEnvironment(settingsEnvironment: settingsEnvironment)
        
        // Create text generation and reader environments
        let textGenerationEnvironment = TextGenerationEnvironment()
        self.environment = ReaderEnvironment(
            textGenerationEnvironment: textGenerationEnvironment,
            settingsEnvironment: settingsEnvironment,
            subscriptionEnvironment: subscriptionEnvironment
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
