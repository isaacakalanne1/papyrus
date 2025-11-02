//
//  DemoNetworkOperationPerformer.swift
//  NetworkOperationPerformer
//
//  Created by Isaac Akalanne on 02/11/2025.
//

import Foundation
import NetworkOperationPerformer
import NetworkOperationPerformerMocks

// Note: You can run this code via the DemoNetworkOperationPerformer target

@main
struct DemoNetworkOperationPerformer {
    static func main() async {
        print("=== NetworkOperationPerformer Demo ===\n")

        // 1) Demos using a MockWaiter (kept local to this file for convenience).
        await demo_availableImmediately()
        await demo_availableWithinTimeout()
        await demo_timesOutBeforeAvailable()

        // 2) Real network demo using NWPathMonitor-backed waiter.
        // Behaviour depends on your current connectivity.
        await demo_realNetwork(waitSeconds: 5)
    }
}

// MARK: - Demo Scenarios (using a mock waiter)

private func demo_availableImmediately() async {
    print("[Scenario A] Available immediately:")
    let performer = NetworkOperationPerformer(waiter: MockWaiter(.availableImmediately))
    let result = await performer.invokeUponNetworkAccess(within: .seconds(3)) {
        // This closure runs immediately (timeout becomes irrelevant).
        // Simulate some async work:
        try? await Task.sleep(nanoseconds: 150_000_000)
        return "✅ ran immediately"
    }
    print("Result:", result, "\n")
}

private func demo_availableWithinTimeout() async {
    print("[Scenario B] Becomes available within timeout:")
    let performer = NetworkOperationPerformer(waiter: MockWaiter(.availableAfter(.seconds(1))))
    let result = await performer.invokeUponNetworkAccess(within: .seconds(3)) {
        // Runs after ~1s when network becomes available; timeout is ignored once started.
        try? await Task.sleep(nanoseconds: 100_000_000)
        return "✅ ran after availability"
    }
    print("Result:", result, "\n")
}

private func demo_timesOutBeforeAvailable() async {
    print("[Scenario C] Times out before availability:")
    let performer = NetworkOperationPerformer(waiter: MockWaiter(.never))
    let result = await performer.invokeUponNetworkAccess(within: .milliseconds(300)) {
        // This should NOT run.
        return "❌ should not run"
    }
    print("Result:", result, "\n")
}

// MARK: - Real NWPathMonitor-backed demo

private func demo_realNetwork(waitSeconds: Int) async {
    print("[Scenario D] Real network (NWPathMonitor), timeout \(waitSeconds)s:")
    let performer = NetworkOperationPerformer(waiter: DefaultNetworkAvailabilityWaiter(/* requiredInterfaceType: .wifi */))
    let result = await performer.invokeUponNetworkAccess(within: .seconds(waitSeconds)) {
        // This runs only if the network is available within the timeout.
        "🌐 real network closure ran"
    }
    print("Result:", result, "\n")
}
