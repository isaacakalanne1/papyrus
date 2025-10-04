//
//  Chapter+Arrange.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
@testable import TextGeneration

public extension Chapter {
    static var arrange: Chapter {
        arrange()
    }
    
    static func arrange(
        id: UUID = UUID(),
        content: String = "Test chapter content"
    ) -> Chapter {
        .init(
            id: id,
            content: content
        )
    }
}