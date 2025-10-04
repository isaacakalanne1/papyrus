//
//  OpenRouterResponse+Arrange.swift
//  TextGeneration
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import Foundation
import SDNetworkCore

public extension OpenRouterResponse {
    static var arrange: OpenRouterResponse {
        arrange()
    }
    
    static func arrange(
        choices: [Choice] = [.arrange]
    ) -> OpenRouterResponse {
        .init(choices: choices)
    }
}

public extension OpenRouterResponse.Choice {
    static var arrange: OpenRouterResponse.Choice {
        arrange()
    }
    
    static func arrange(
        message: Message = .arrange
    ) -> OpenRouterResponse.Choice {
        .init(message: message)
    }
}

public extension OpenRouterResponse.Choice.Message {
    static var arrange: OpenRouterResponse.Choice.Message {
        arrange()
    }
    
    static func arrange(
        content: String = "Generated content"
    ) -> OpenRouterResponse.Choice.Message {
        .init(content: content)
    }
}
