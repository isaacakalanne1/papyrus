import Foundation

public enum SDNetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case httpError(statusCode: Int)
}

public class SDNetworkCore {
    private let apiKey: String
    private let session: URLSession
    
    public init(apiKey: String = "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") {
        self.apiKey = apiKey
        self.session = URLSession.shared
    }
    
    public func request<E: Endpoint>(_ endpoint: E) async throws -> E.Response {
        let request = try createURLRequest(from: endpoint)
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw SDNetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw SDNetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(E.Response.self, from: data)
        } catch {
            throw SDNetworkError.decodingError(error)
        }
    }
    
    private func createURLRequest<E: Endpoint>(from endpoint: E) throws -> URLRequest {
        guard let url = URL(string: endpoint.baseURL + endpoint.path) else {
            throw SDNetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = 1200 // 20 minutes for long AI operations
        
        // Add headers
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add API key
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // Add body if present
        request.httpBody = endpoint.body
        
        return request
    }
    
    public func requestContent<E: Endpoint>(_ endpoint: E) async throws -> String where E.Response == OpenRouterResponse {
        let response = try await request(endpoint)
        
        guard let firstChoice = response.choices.first else {
            throw SDNetworkError.invalidResponse
        }
        
        return firstChoice.message.content
    }
}