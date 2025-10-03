import Foundation
import SDNetworkCore

struct OpenRouterMessage: Encodable {
    let role: String
    let content: String
}

struct OpenRouterRequest: Encodable {
    let model: String
    let messages: [OpenRouterMessage]
    
    init(
        model: String = "x-ai/grok-4-fast",
        messages: [OpenRouterMessage]
    ) {
        self.model = model
        self.messages = messages
    }
}

// Helper to create the body data for all text generation endpoints
extension OpenRouterRequest {
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
