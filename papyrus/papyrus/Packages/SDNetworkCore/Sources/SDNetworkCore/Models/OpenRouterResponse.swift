import Foundation

public struct OpenRouterResponse: Decodable {
    public let choices: [Choice]
    
    public init(
        choices: [Choice]
    ) {
        self.choices = choices
    }
    
    public struct Choice: Decodable {
        public let message: Message
        
        public init(
            message: Message
        ) {
            self.message = message
        }
        
        public struct Message: Decodable {
            public let content: String
            
            public init(
                content: String
            ) {
                self.content = content
            }
        }
    }
}
