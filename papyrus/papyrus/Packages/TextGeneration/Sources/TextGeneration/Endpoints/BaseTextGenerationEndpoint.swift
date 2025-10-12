import Foundation

struct OpenRouterMessage: Encodable {
    let role: String
    let content: String
}

struct OpenRouterReasoning: Encodable {
    let temperature: Float?
    let max_tokens: Int?
    
    init(
        max_tokens: Int = 10_000,
        temperature: Float? = nil
    ) {
        self.max_tokens = max_tokens
        self.temperature = temperature
    }
}

struct OpenRouterRequest: Encodable {
    let model: String
    let messages: [OpenRouterMessage]
    let temperature: Float?
    let max_tokens: Int?
    
    init(
        model: String = "deepseek/deepseek-chat-v3.1",
        messages: [OpenRouterMessage],
        reasoning: OpenRouterReasoning = OpenRouterReasoning()
    ) {
        self.model = model
        self.messages = messages
        self.temperature = reasoning.temperature
        self.max_tokens = reasoning.max_tokens
    }
}

// Helper to create the body data for all text generation endpoints
extension OpenRouterRequest {
    func toData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
