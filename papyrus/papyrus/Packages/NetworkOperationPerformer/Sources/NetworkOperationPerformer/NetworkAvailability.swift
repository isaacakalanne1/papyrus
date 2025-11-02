//
//  NetworkAvailabilityWaiting.swift
//  NetworkOperationPerformer
//
//  Created by Isaac Akalanne on 02/11/2025.
//

/// Abstraction that can be faked in tests (so you don't need real network state).
@available(macOS 13, iOS 16.0, *)
public protocol NetworkAvailabilityWaiting: Sendable {
    /// Returns `.available` if network access is observed before `timeout`,
    /// otherwise `.timedOut`. Should respect cooperative cancellation.
    func waitForAvailability(within timeout: Duration) async -> NetworkAvailabilityOutcome
}

public enum NetworkAvailabilityOutcome: Sendable {
    case available
    case timedOut
}
