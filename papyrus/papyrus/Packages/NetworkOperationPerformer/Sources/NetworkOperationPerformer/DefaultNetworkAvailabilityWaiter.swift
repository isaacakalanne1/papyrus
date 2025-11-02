//
//  DefaultNetworkAvailabilityWaiter.swift
//  NetworkOperationPerformer
//
//  Created by Isaac Akalanne on 02/11/2025.
//

import Foundation
import Network

import Foundation
import Network

@available(macOS 13, iOS 16.0, *)
public struct DefaultNetworkAvailabilityWaiter: NetworkAvailabilityWaiting, Sendable {

    private let requiredInterfaceType: NWInterface.InterfaceType?

    public init(requiredInterfaceType: NWInterface.InterfaceType? = nil) {
        self.requiredInterfaceType = requiredInterfaceType
    }

    public func waitForAvailability(within timeout: Duration) async -> NetworkAvailabilityOutcome {
        let (monitor, queue) = makeMonitor()
        monitor.start(queue: queue)
        defer {
            monitor.cancel()
        }

        // Fast path: already online.
        if monitor.currentPath.status == .satisfied {
            return .available
        }

        let stream = availabilityStream(for: monitor)
        return await raceAvailabilityWithTimeout(stream, timeout: timeout)
    }

    // MARK: - Private helpers (scoped to this type)

    /// Builds a per-call NWPathMonitor and private queue.
    private func makeMonitor() -> (monitor: NWPathMonitor, queue: DispatchQueue) {
        let monitor: NWPathMonitor = {
            if let iface = requiredInterfaceType {
                return NWPathMonitor(requiredInterfaceType: iface)
            } else {
                return NWPathMonitor()
            }
        }()
        let queue = DispatchQueue(label: "net.alba.NetworkAvailabilityWaiter.\(UUID().uuidString)")
        return (monitor, queue)
    }

    /// Turns path updates into an AsyncStream<Bool> where `true` means “satisfied”.
    private func availabilityStream(for monitor: NWPathMonitor) -> AsyncStream<Bool> {
        AsyncStream<Bool> { continuation in
            monitor.pathUpdateHandler = { path in
                continuation.yield(path.status == .satisfied)
            }
            continuation.onTermination = { _ in /* owner cancels in defer */ }
        }
    }

    /// Races availability vs timeout; first to complete wins.
    private func raceAvailabilityWithTimeout(
        _ stream: AsyncStream<Bool>,
        timeout: Duration
    ) async -> NetworkAvailabilityOutcome {
        await withTaskGroup(of: NetworkAvailabilityOutcome.self) { group in
            group.addTask {
                for await ok in stream {
                    if ok {
                        return .available
                    }
                    if Task.isCancelled {
                        break
                    }
                }
                return .timedOut
            }
            group.addTask {
                try? await ContinuousClock().sleep(for: timeout)
                return .timedOut
            }
            let first = await group.next()!
            group.cancelAll()
            return first
        }
    }
}
