import Foundation

public protocol Endpoint {
    associatedtype Response: Decodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

// Default implementations
public extension Endpoint {
    var baseURL: String {
        "https://openrouter.ai"
    }
    
    var headers: [String: String] {
        [
            "Content-Type": "application/json"
        ]
    }
    
    var method: HTTPMethod {
        .post
    }
}
