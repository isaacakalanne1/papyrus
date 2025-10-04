import Foundation
import FirebaseFirestore

public enum SDNetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case httpError(statusCode: Int)
}

public class SDNetworkCore {
    private let session: URLSession
    
    public init() {
        self.session = URLSession.shared
    }
    
    public func getAuthKey() async throws -> String {
        let db = Firestore.firestore()
        let document = try await db.collection("config").document("api_keys").getDocument()
        
        guard document.exists else {
            throw NSError(domain: "APIRequestType", code: 404, userInfo: [NSLocalizedDescriptionKey: "API keys document not found"])
        }
        
        guard let apiKey = document.data()?["openrouter_api_key"] as? String,
              !apiKey.isEmpty else {
            throw NSError(domain: "APIRequestType", code: 401, userInfo: [NSLocalizedDescriptionKey: "OpenRouter API key not found"])
        }
        return apiKey
    }
    
    public func request<E: Endpoint>(_ endpoint: E) async throws -> E.Response {
        let apiKey = try await getAuthKey()
        let request = try createURLRequest(
            from: endpoint,
            apiKey: apiKey
        )
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
    
    private func createURLRequest<E: Endpoint>(
        from endpoint: E,
        apiKey: String
    ) throws -> URLRequest {
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
