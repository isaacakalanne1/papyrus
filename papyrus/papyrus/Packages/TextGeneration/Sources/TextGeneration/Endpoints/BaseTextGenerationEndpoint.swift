import Foundation

struct OpenRouterMessage: Encodable {
    let role: String
    let content: String
}

struct OpenRouterReasoning: Encodable {
    let max_tokens: Int
    
    init(max_tokens: Int = 5000) {
        self.max_tokens = max_tokens
    }
}

struct OpenRouterRequest: Encodable {
    let model: String
    let messages: [OpenRouterMessage]
    let reasoning: OpenRouterReasoning?
    
    init(
        model: String = "x-ai/grok-4-fast",
        messages: [OpenRouterMessage],
        reasoning: OpenRouterReasoning? = nil
    ) {
        self.model = model
        self.messages = messages
        self.reasoning = reasoning
    }
}

// Helper to create the body data for all text generation endpoints
extension OpenRouterRequest {
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
