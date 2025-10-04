//
//  EndpointTests.swift
//  SDNetworkCore
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import Foundation
@testable import SDNetworkCore

class EndpointTests {
    
    // MARK: - Test Endpoint Implementations
    
    struct TestEndpoint: Endpoint {
        typealias Response = TestResponse
        
        let path: String
        let body: Data?
        
        init(path: String, body: Data? = nil) {
            self.path = path
            self.body = body
        }
    }
    
    struct CustomEndpoint: Endpoint {
        typealias Response = TestResponse
        
        let baseURL: String
        let path: String
        let method: HTTPMethod
        let headers: [String: String]
        let body: Data?
        
        init(
            baseURL: String,
            path: String,
            method: HTTPMethod,
            headers: [String: String],
            body: Data?
        ) {
            self.baseURL = baseURL
            self.path = path
            self.method = method
            self.headers = headers
            self.body = body
        }
    }
    
    struct TestResponse: Decodable {
        let message: String
    }
    
    // MARK: - Default Implementation Tests
    
    @Test
    func endpoint_defaultBaseURL() {
        let endpoint = TestEndpoint(path: "/test")
        #expect(endpoint.baseURL == "https://openrouter.ai")
    }
    
    @Test
    func endpoint_defaultHeaders() {
        let endpoint = TestEndpoint(path: "/test")
        let expectedHeaders = ["Content-Type": "application/json"]
        #expect(endpoint.headers == expectedHeaders)
    }
    
    @Test
    func endpoint_defaultMethod() {
        let endpoint = TestEndpoint(path: "/test")
        #expect(endpoint.method == .post)
    }
    
    // MARK: - Custom Implementation Tests
    
    @Test(arguments: [
        "https://api.example.com",
        "https://custom.domain.org",
        "http://localhost:8080"
    ])
    func endpoint_customBaseURL(customBaseURL: String) {
        let endpoint = CustomEndpoint(
            baseURL: customBaseURL,
            path: "/test",
            method: .get,
            headers: [:],
            body: nil
        )
        #expect(endpoint.baseURL == customBaseURL)
    }
    
    @Test(arguments: [
        "/api/v1/users",
        "/data",
        "/complex/path/with/params"
    ])
    func endpoint_customPath(customPath: String) {
        let endpoint = TestEndpoint(path: customPath)
        #expect(endpoint.path == customPath)
    }
    
    @Test(arguments: [
        HTTPMethod.get,
        HTTPMethod.post,
        HTTPMethod.put,
        HTTPMethod.delete,
        HTTPMethod.patch
    ])
    func endpoint_customMethod(customMethod: HTTPMethod) {
        let endpoint = CustomEndpoint(
            baseURL: "https://test.com",
            path: "/test",
            method: customMethod,
            headers: [:],
            body: nil
        )
        #expect(endpoint.method == customMethod)
    }
    
    @Test
    func endpoint_customHeaders() {
        let customHeaders = [
            "Authorization": "Bearer token123",
            "Accept": "application/json",
            "X-Custom-Header": "custom-value"
        ]
        
        let endpoint = CustomEndpoint(
            baseURL: "https://test.com",
            path: "/test",
            method: .get,
            headers: customHeaders,
            body: nil
        )
        
        #expect(endpoint.headers == customHeaders)
    }
    
    @Test
    func endpoint_customBody() {
        let testData = "test body content".data(using: .utf8)
        let endpoint = TestEndpoint(path: "/test", body: testData)
        
        #expect(endpoint.body == testData)
    }
    
    @Test
    func endpoint_nilBody() {
        let endpoint = TestEndpoint(path: "/test", body: nil)
        #expect(endpoint.body == nil)
    }
    
    // MARK: - Protocol Conformance Tests
    
    @Test
    func endpoint_hasRequiredProperties() {
        let endpoint = TestEndpoint(path: "/test")
        
        // Test that all required protocol properties are accessible
        let _: String = endpoint.baseURL
        let _: String = endpoint.path
        let _: HTTPMethod = endpoint.method
        let _: [String: String] = endpoint.headers
        let _: Data? = endpoint.body
        
        // Test Response type is Decodable
        #expect(TestResponse.self is Decodable.Type)
    }
    
    @Test
    func endpoint_responseTypeConformance() {
        // Verify that Response type conforms to Decodable
        let jsonData = "{\"message\":\"test\"}".data(using: .utf8)!
        
        do {
            let response = try JSONDecoder().decode(TestResponse.self, from: jsonData)
            #expect(response.message == "test")
        } catch {
            #expect(Bool(false), "TestResponse should be decodable")
        }
    }
    
    // MARK: - Integration Tests
    
    @Test
    func endpoint_completeConfiguration() {
        let jsonBody = "{\"key\":\"value\"}".data(using: .utf8)
        let endpoint = CustomEndpoint(
            baseURL: "https://api.custom.com",
            path: "/v2/endpoint",
            method: .patch,
            headers: [
                "Authorization": "Bearer abc123",
                "Content-Type": "application/json",
                "Accept": "application/json"
            ],
            body: jsonBody
        )
        
        #expect(endpoint.baseURL == "https://api.custom.com")
        #expect(endpoint.path == "/v2/endpoint")
        #expect(endpoint.method == .patch)
        #expect(endpoint.headers["Authorization"] == "Bearer abc123")
        #expect(endpoint.headers["Content-Type"] == "application/json")
        #expect(endpoint.headers["Accept"] == "application/json")
        #expect(endpoint.body == jsonBody)
    }
    
    @Test
    func endpoint_defaultOverrides() {
        // Test that custom implementations override defaults
        let customEndpoint = CustomEndpoint(
            baseURL: "https://custom.api.com",
            path: "/custom",
            method: .get,
            headers: ["Custom": "Header"],
            body: "custom".data(using: .utf8)
        )
        
        // Should not use default values
        #expect(customEndpoint.baseURL != "https://openrouter.ai")
        #expect(customEndpoint.method != .post)
        #expect(customEndpoint.headers != ["Content-Type": "application/json"])
    }
}