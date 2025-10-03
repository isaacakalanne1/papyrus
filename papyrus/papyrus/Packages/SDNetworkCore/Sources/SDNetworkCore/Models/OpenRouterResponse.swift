import Foundation

public struct OpenRouterResponse: Decodable {
    public let choices: [Choice]
    
    public struct Choice: Decodable {
        public let message: Message
        
        public struct Message: Decodable {
            public let content: String
        }
    }
}