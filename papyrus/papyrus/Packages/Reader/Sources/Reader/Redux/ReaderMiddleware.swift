//
//  ReaderMiddleware.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import ReduxKit

@MainActor
let readerMiddleware: Middleware<ReaderState, ReaderAction,  ReaderEnvironmentProtocol> = { state, action, environment in
    switch action {
    case .createChapter:
        do {
            let chapter = try await environment.createChapter()
            return .onCreatedChapter(chapter)
        } catch {
            return .failedToCreateChapter
        }
    case .onCreatedChapter,
            .failedToCreateChapter:
        return nil
    }
}
