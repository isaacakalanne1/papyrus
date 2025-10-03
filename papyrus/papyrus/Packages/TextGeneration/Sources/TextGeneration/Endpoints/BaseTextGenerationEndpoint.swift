import Foundation
import SDNetworkCore

struct OpenRouterMessage: Encodable {
    let role: String
    let content: String
}

struct OpenRouterRequest: Encodable {
    let model: String
    let messages: [OpenRouterMessage]
}

// Helper to create the body data for all text generation endpoints
extension OpenRouterRequest {
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}