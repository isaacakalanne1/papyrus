//
//  Chapter+Preview.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 20/03/2026.
//

import Foundation

public extension Chapter {
    var firstLine: String {
        content
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .first(where: { !$0.isEmpty })
            ?? "..."
    }
}
