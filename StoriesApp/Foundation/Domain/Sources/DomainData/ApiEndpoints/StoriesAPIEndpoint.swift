//
//  StoriesAPIEndpoint.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Networking

/// API endpoints for the stories app
public enum StoriesAPIEndpoint {
    case getStories(page: Int, pageSize: Int)
}

extension StoriesAPIEndpoint: EndpointType {
    public var baseUrl: URL? {
        URL(string: "https://somedomain.com")
    }
    
    public var path: String {
        switch self {
        case .getStories:
            return "/api/stories"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .getStories:
            return .get
        }
    }
    
    public var urlQueries: [String: String]? {
        switch self {
        case let .getStories(page, pageSize):
            return [
                "page": "\(page)",
                "pageSize": "\(pageSize)"
            ]
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getStories:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }
    
    public var bodyParameters: BodyParameter? {
        switch self {
        case .getStories:
            return nil
        }
    }
}

