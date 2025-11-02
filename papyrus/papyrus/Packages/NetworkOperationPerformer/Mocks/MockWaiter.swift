//
//  MockWaiter.swift
//  NetworkOperationPerformer
//
//  Created by Isaac Akalanne on 02/11/2025.
//

import Foundation
@testable import NetworkOperationPerformer

public struct MockWaiter: NetworkAvailabilityWaiting {
    public enum Script: Sendable {
        case availableImmediately
        case availableAfter(Duration)
        case never
    }

    private let script: Script
    public init(_ script: Script) {
        self.script = script
    }

    public func waitForAvailability(within timeout: Duration) async -> NetworkAvailabilityOutcome {
        switch script {
        case .availableImmediately:
            return .available
        case .availableAfter(let delay):
            return await withTaskGroup(of: NetworkAvailabilityOutcome.self) { group in
                group.addTask {
                    try? await ContinuousClock().sleep(for: delay)
                    return .available
                }
                group.addTask {
                    try? await ContinuousClock().sleep(for: timeout)
                    return .timedOut
                }
                let first = await group.next()!
                group.cancelAll()
                return first
            }
        case .never:
            try? await ContinuousClock().sleep(for: timeout)
            return .timedOut
        }
    }
}
