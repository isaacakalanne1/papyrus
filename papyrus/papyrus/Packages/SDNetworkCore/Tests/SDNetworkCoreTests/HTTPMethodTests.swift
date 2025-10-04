//
//  HTTPMethodTests.swift
//  SDNetworkCore
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
@testable import SDNetworkCore

class HTTPMethodTests {
    
    // MARK: - Raw Value Tests
    
    @Test(arguments: [
        (HTTPMethod.get, "GET"),
        (HTTPMethod.post, "POST"),
        (HTTPMethod.put, "PUT"),
        (HTTPMethod.delete, "DELETE"),
        (HTTPMethod.patch, "PATCH")
    ])
    func httpMethod_rawValue(method: HTTPMethod, expectedRawValue: String) {
        #expect(method.rawValue == expectedRawValue)
    }
    
    // MARK: - Initialization from Raw Value Tests
    
    @Test(arguments: [
        ("GET", HTTPMethod.get),
        ("POST", HTTPMethod.post),
        ("PUT", HTTPMethod.put),
        ("DELETE", HTTPMethod.delete),
        ("PATCH", HTTPMethod.patch)
    ])
    func httpMethod_initFromRawValue(rawValue: String, expectedMethod: HTTPMethod) {
        let method = HTTPMethod(rawValue: rawValue)
        #expect(method == expectedMethod)
    }
    
    @Test(arguments: [
        "get",
        "post",
        "invalid",
        "",
        "UNKNOWN"
    ])
    func httpMethod_initFromInvalidRawValue(invalidRawValue: String) {
        let method = HTTPMethod(rawValue: invalidRawValue)
        #expect(method == nil)
    }
    
    // MARK: - Equality Tests
    
    @Test
    func httpMethod_equality() {
        #expect(HTTPMethod.get == HTTPMethod.get)
        #expect(HTTPMethod.post == HTTPMethod.post)
        #expect(HTTPMethod.put == HTTPMethod.put)
        #expect(HTTPMethod.delete == HTTPMethod.delete)
        #expect(HTTPMethod.patch == HTTPMethod.patch)
        
        #expect(HTTPMethod.get != HTTPMethod.post)
        #expect(HTTPMethod.post != HTTPMethod.put)
        #expect(HTTPMethod.put != HTTPMethod.delete)
        #expect(HTTPMethod.delete != HTTPMethod.patch)
    }
    
    // MARK: - Case Iteration Tests
    
    @Test
    func httpMethod_allCases() {
        let allMethods: [HTTPMethod] = [.get, .post, .put, .delete, .patch]
        let expectedRawValues = ["GET", "POST", "PUT", "DELETE", "PATCH"]
        
        #expect(allMethods.count == 5)
        
        for (index, method) in allMethods.enumerated() {
            #expect(method.rawValue == expectedRawValues[index])
        }
    }
}