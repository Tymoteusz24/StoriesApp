//
//  UserProfileService.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Domain
import Networking

/// Service implementation for fetching user profiles from API
public final actor UserProfileService: UserProfileServiceProtocol {
    private let apiClient: IAPIClientService
    private let mapper: UserProfilesMapper
    
    public init(apiClient: IAPIClientService) {
        self.apiClient = apiClient
        self.mapper = UserProfilesMapper()
    }
    
    public func fetchProfiles() async throws -> [UserProfile] {
        let endpoint = StoriesAPIEndpoint.getProfiles
        return try await apiClient.request(endpoint, mapper: mapper)
    }
}

