//
//  NetworkOperationPerformer.swift
//  NetworkOperationPerformer
//
//  Created by Isaac Akalanne on 02/11/2025.
//

/// A reusable, thread-safe performer that executes work *only when* network access is available
/// either immediately or within a specified timeout. Uses structured concurrency & actors.
public actor NetworkOperationPerformer {

    private let waiter: NetworkAvailabilityWaiting

    /// Designated initializer. Inject a fake waiter in tests.
    public init(waiter: NetworkAvailabilityWaiting = DefaultNetworkAvailabilityWaiter()) {
        self.waiter = waiter
    }

    /// Invokes `closure` if and only if access to the network is initially available
    /// or becomes available within `timeoutDuration`.
    ///
    /// - Important: Once network access becomes available *within* the timeout, the closure
    ///   is started and the timeout is no longer considered (the closure is allowed to run to completion).
    /// - Returns: `.success(T)` if the closure ran (and completed) or
    ///   `.failure(.timedOut | .cancelled)` if it didn’t start due to timeout/cancellation.
    public func invokeUponNetworkAccess<T: Sendable>(
        within timeoutDuration: Duration,
        _ closure: @escaping @Sendable () async -> T
    ) async -> Result<T, NetworkOperationExecutionError> {

        // If our caller already cancelled, report early.
        if Task.isCancelled {
            return .failure(.cancelled)
        }

        // Wait for availability (or timeout) *before* starting the closure.
        let outcome = await waiter.waitForAvailability(within: timeoutDuration)

        switch outcome {
        case .timedOut:
            return .failure(.timedOut)

        case .available:
            let value = await closure()
            return .success(value)
        }
    }
}
