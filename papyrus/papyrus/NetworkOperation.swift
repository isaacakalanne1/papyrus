//
//  NetworkOperation.swift
//  papyrus
//
//  Created by Isaac Akalanne on 02/11/2025.
//

import Foundation

// MARK: - Errors

enum APIError: Error {
    case invalidRequest
    case invalidResponse
    case badStatus(Int, Data?)
    case emptyData
    case decoding(Error, Data)
    case transport(Error)
    case cancelled
}

// MARK: - Transport (pluggable for tests)

protocol Cancellable { func cancel() }
extension URLSessionDataTask: Cancellable {}

protocol Transport {
    @discardableResult
    func load(_ req: URLRequest, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) -> Cancellable
}

final class URLSessionTransport: Transport {
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }
    @discardableResult
    func load(_ req: URLRequest, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) -> Cancellable {
        let task = session.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(err)); return }
            completion(.success((data ?? Data(), resp!)))
        }
        task.resume()
        return task
    }
}

// MARK: - Decoder factory (snake_case, ISO8601 + fallback)

struct JSONDecoderFactory {
    static func make() -> JSONDecoder {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        if #available(iOS 11.0, macOS 10.13, *) {
            dec.dateDecodingStrategy = .iso8601
        } else {
            dec.dateDecodingStrategy = .formatted(DateFormatter.iso8601like)
        }
        return dec
    }
}
extension DateFormatter {
    static var iso8601like: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return f
    }()
}

// MARK: - Client

final class NetworkClient {
    private let transport: Transport
    private let decoder: JSONDecoder
    init(transport: Transport = URLSessionTransport(), decoder: JSONDecoder = JSONDecoderFactory.make()) {
        self.transport = transport
        self.decoder = decoder
    }

    @discardableResult
    func requestDecodable<T: Decodable>(_ req: URLRequest, as: T.Type,
                                        completion: @escaping (Result<T, APIError>) -> Void) -> Cancellable {
        return transport.load(req) { [decoder] result in
            switch result {
            case .failure(let err):
                let nserr = err as NSError
                if nserr.domain == NSURLErrorDomain, nserr.code == NSURLErrorCancelled {
                    completion(.failure(.cancelled))
                } else {
                    completion(.failure(.transport(err)))
                }
            case .success(let (data, resp)):
                guard let http = resp as? HTTPURLResponse else { completion(.failure(.invalidResponse)); return }
                guard (200..<300).contains(http.statusCode) else {
                    completion(.failure(.badStatus(http.statusCode, data.isEmpty ? nil : data)))
                    return
                }
                guard !data.isEmpty else {
                    completion(.failure(.emptyData))
                    return
                }
                do { completion(.success(try decoder.decode(T.self, from: data))) }
                catch { completion(.failure(.decoding(error, data))) }
            }
        }
    }

    // Raw data variant (useful for 204 / image / file endpoints)
    @discardableResult
    func requestData(_ req: URLRequest, completion: @escaping (Result<Data, APIError>) -> Void) -> Cancellable {
        return transport.load(req) { result in
            switch result {
            case .failure(let err): completion(.failure(.transport(err)))
            case .success(let (data, resp)):
                guard let http = resp as? HTTPURLResponse else { completion(.failure(.invalidResponse)); return }
                guard (200..<300).contains(http.statusCode) else { completion(.failure(.badStatus(http.statusCode, data))) ; return }
                completion(.success(data))
            }
        }
    }
}

// MARK: - Quick helpers

enum HTTPMethod: String { case GET, POST, PUT, PATCH, DELETE }
func makeRequest(url: URL, method: HTTPMethod = .GET, headers: [String:String] = [:], body: Data? = nil, timeout: TimeInterval = 30) -> URLRequest {
    var r = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
    r.httpMethod = method.rawValue
    for (k,v) in headers { r.setValue(v, forHTTPHeaderField: k) }
    r.httpBody = body
    return r
}

func shouldRetry(status: Int) -> Bool {
    return status == 429 || (500...599).contains(status)
}

// Base delays 0.2s, 0.5s, 1.0s (cap ~2s)
func backoffDelay(attempt: Int) -> TimeInterval {
    switch attempt {
    case 0: return 0.2
    case 1: return 0.5
    default: return 1.0
    }
}

// GET + retry wrapper
@discardableResult
func getWithRetry<T: Decodable>(_ client: NetworkClient,
                                _ req: URLRequest,
                                as: T.Type,
                                maxAttempts: Int = 3,
                                completion: @escaping (Result<T, APIError>) -> Void) -> Cancellable {
    var currentAttempt = 0
    var currentTask: Cancellable?

    func run() {
        currentTask = client.requestDecodable(req, as: T.self) { result in
            switch result {
            case .success:
                completion(result)
            case .failure(let err):
                if case .badStatus(let code, _) = err, shouldRetry(status: code), currentAttempt < maxAttempts - 1 {
                    let delay = backoffDelay(attempt: currentAttempt)
                    currentAttempt += 1
                    DispatchQueue.global().asyncAfter(deadline: .now() + delay) { run() }
                } else {
                    completion(result)
                }
            }
        }
    }
    run()
    // Return a composite cancellable that cancels the in-flight task
    return CancelBox { currentTask?.cancel() }
}

struct CancelBox: Cancellable { let cancelClosure: () -> Void; func cancel() { cancelClosure() } }

// MARK: - Mock transport

final class MockTask: Cancellable { private(set) var isCancelled = false; func cancel() { isCancelled = true } }

final class MockTransport: Transport {
    struct ResponsePlan {
        let status: Int
        let body: Data
        let headers: [String:String]
        init(status: Int, json: String = "{}", headers: [String:String] = [:]) {
            self.status = status
            self.body = json.data(using: .utf8) ?? Data()
            self.headers = headers
        }
    }
    private var queue: [ResponsePlan]
    init(queue: [ResponsePlan]) { self.queue = queue }
    @discardableResult
    func load(_ req: URLRequest, completion: @escaping (Result<(Data, URLResponse), Error>) -> Void) -> Cancellable {
        let task = MockTask()
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.01) {
            guard !task.isCancelled else { completion(.failure(NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled))); return }
            let plan = self.queue.isEmpty ? ResponsePlan(status: 500, json: "{}") : self.queue.removeFirst()
            let url = req.url ?? URL(string: "https://example.invalid")!
            let resp = HTTPURLResponse(url: url, statusCode: plan.status, httpVersion: "HTTP/1.1", headerFields: plan.headers)!
            completion(.success((plan.body, resp)))
        }
        return task
    }
}

class ExampleClass {
    init() {
        
    }
    
    func testFunc() {
        struct User: Decodable { let id: Int; let name: String }
        let okPlan = MockTransport.ResponsePlan(status: 200, json: #"{"id": 7, "name": "Alba"}"#)
        let clientA = NetworkClient(transport: MockTransport(queue: [okPlan]))
        let reqA = makeRequest(url: URL(string: "https://api.example.com/user/7")!)
        clientA.requestDecodable(reqA, as: User.self) { result in
            print("A) \(result)") // => success(User(id:7, name:"Alba"))
        }

        let notFound = MockTransport.ResponsePlan(status: 404, json: #"{"error":"nope"}"#)
        let clientB = NetworkClient(transport: MockTransport(queue: [notFound]))
        clientB.requestDecodable(reqA, as: User.self) { result in
            // => failure(.badStatus(404, bodyData))
            print("B) \(result)")
        }

    }
}
