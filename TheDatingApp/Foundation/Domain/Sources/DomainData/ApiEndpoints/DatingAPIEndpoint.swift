//
//  DatingAPIEndpoint.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Networking

/// API endpoints for the dating app
public enum DatingAPIEndpoint {
    case getProfiles
}

extension DatingAPIEndpoint: EndpointType {
    public var baseUrl: URL? {
        URL(string: "https://raw.githubusercontent.com")
    }
    
    public var path: String {
        switch self {
        case .getProfiles:
            return "/downapp/sample/main/sample.json"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .getProfiles:
            return .get
        }
    }
    
    public var urlQueries: [String: String]? {
        switch self {
        case .getProfiles:
            return nil
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .getProfiles:
            return [
                "Accept": "application/json",
                "Content-Type": "application/json"
            ]
        }
    }
    
    public var bodyParameters: BodyParameter? {
        switch self {
        case .getProfiles:
            return nil
        }
    }
}

