//
//  NetworkOperationExecutionError.swift
//  NetworkOperationPerformer
//
//  Created by Isaac Akalanne on 02/11/2025.
//

import Foundation

public enum NetworkOperationExecutionError: Error, Sendable {
    /// Network wasn’t available before the timeout expired.
    case timedOut
    /// The caller task was cancelled before the operation began.
    case cancelled
}
