//
//  papyrusApp.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI
import Reader
import TextGeneration

@main
struct papyrusApp: App {
    let environment: ReaderEnvironmentProtocol
    
    init() {
        let textGenerationEnvironment = TextGenerationEnvironment()

        self.environment = ReaderEnvironment(
            textGenerationEnvironment: textGenerationEnvironment
        )
    }

    var body: some Scene {
        WindowGroup {
            ReaderRootView(environment: environment)
        }
    }
}
