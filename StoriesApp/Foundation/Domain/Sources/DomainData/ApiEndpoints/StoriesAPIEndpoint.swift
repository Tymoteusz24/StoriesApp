//
//  StoriesAPIEndpoint.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Networking

/// API endpoints for the stories app
public enum StoriesAPIEndpoint {
    case getProfiles
    case getStories(page: Int, pageSize: Int)
}

extension StoriesAPIEndpoint: EndpointType {
    public var baseUrl: URL? {
        URL(string: "https://raw.githubusercontent.com")
    }
    
    public var path: String {
        switch self {
        case .getProfiles:
            return "/downapp/sample/main/sample.json"
        case .getStories:
            return "/downapp/sample/main/stories.json"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .getProfiles, .getStories:
            return .get
        }
    }
    
    public var urlQueries: [String: String]? {
        switch self {
        case .getProfiles:
            return nil
        case let .getStories(page, pageSize):
            return [
                "page": "\(page)",
                "pageSize": "\(pageSize)"
            ]
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getProfiles, .getStories:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }
    
    public var bodyParameters: BodyParameter? {
        switch self {
        case .getProfiles, .getStories:
            return nil
        }
    }
}

