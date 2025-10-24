// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Logger

public enum APIError: Error {
    case invalidEndpoint
    case badServerResponse
    case networkError(error: Error)
    case parsing(error: Error)
}

public typealias APIResponse = (data: Data, statusCode: Int)

public protocol IAPIClientService: Sendable {
    func request(_ endpoint: EndpointType) async -> Result<APIResponse, APIError>
    func request<T: Decodable>(_ endpoint: EndpointType, for type: T.Type, decoder: JSONDecoder) async throws -> T
    func request<T, M: Mappable>(_ endpoint: EndpointType, mapper: M) async throws -> T where M.Output == T
}

public extension IAPIClientService {
    func request<T: Decodable>(_ endpoint: EndpointType, for type: T.Type) async throws -> T {
        try await request(endpoint, for: type, decoder: JSONDecoder())
    }
}

public final class APIClientService: IAPIClientService, @unchecked Sendable {
    public struct Configuration: Sendable {
        let baseURL: URL?
        let baseHeaders: [String: String]

        public init(baseURL: URL?, baseHeaders: [String: String]) {
            self.baseURL = baseURL
            self.baseHeaders = baseHeaders
        }

        public static let `default` = Configuration(baseURL: nil, baseHeaders: [:])
    }

    private let logger: ILogger
    private let configuration: Configuration

    public init(logger: ILogger, configuration: Configuration = .default) {
        self.configuration = configuration
        self.logger = logger
    }

    public func request(_ endpoint: EndpointType) async -> Result<APIResponse, APIError> {
        guard let request = buildURLRequest(from: endpoint) else {
            return .failure(.invalidEndpoint)
        }
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200..<400).contains(httpResponse.statusCode) else {
                logger.log(request: request, data: data, response: response as? HTTPURLResponse, error: nil)
                return .failure(.badServerResponse)
            }
            logger.log(request: request, data: data, response: httpResponse, error: nil)
            return .success((data, httpResponse.statusCode))
        } catch {
            logger.log(level: .error, message: "❌ Network error: \(error)")
            logger.log(request: request, data: nil, response: nil, error: error)
            return .failure(.networkError(error: error))
        }
    }

    public func request<T>(
        _ endpoint: EndpointType,
        for _: T.Type,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T where T: Decodable {
        let response = await request(endpoint)
        switch response {
        case let .success(result):
            do {
                let modelResponse = try decoder.decode(T.self, from: result.data)
                return modelResponse
            } catch {
                if let decodingError = error as? DecodingError {
                    logger.log(level: .error, message: "❌ Decoding error in \(T.self): \(decodingError.detailErrorDescription)")
                }
                throw APIError.parsing(error: error)
            }
        case let .failure(failure):
            throw failure
        }
    }

    public func request<T, M: Mappable>(_ endpoint: EndpointType, mapper: M) async throws -> T where T == M.Output {
        let responseModel: M.Input = try await request(endpoint, for: M.Input.self)
        return try mapper.map(responseModel)
    }

    private func buildURLRequest(from endpoint: EndpointType) -> URLRequest? {
        let host = endpoint.baseUrl?.host ?? configuration.baseURL?.host
        guard let host = host else { return nil }

        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = endpoint.path

        if let urlQueries = endpoint.urlQueries {
            var queryItems: [URLQueryItem] = []
            for item in urlQueries {
                queryItems.append(URLQueryItem(name: item.key, value: item.value))
            }

            components.queryItems = queryItems
        }

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue

        let endpointHeaders = endpoint.headers ?? [:]
        let mergedHeaders = configuration.baseHeaders.merging(endpointHeaders) { (_, new) in new }
        request.allHTTPHeaderFields = mergedHeaders

        switch endpoint.bodyParameters {
        case let .data(data):
            request.httpBody = data
        case let .dictionary(dict, options):
            let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: options)
            request.httpBody = jsonData
        case let .encodable(object, encoder):
            let data = try? encoder.encode(object)
            request.httpBody = data
        default:
            break
        }

        return request
    }
}
