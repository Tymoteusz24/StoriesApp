//
//  StoriesRemoteRepository.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Domain
import Networking

public final actor StoriesRemoteRepository {
    private let apiClient: IAPIClientService
    private let mapper: StoriesMapper
    
    public init(apiClient: IAPIClientService) {
        self.apiClient = apiClient
        self.mapper = StoriesMapper()
    }
    
    public func fetchStories(page: Int = 1, pageSize: Int = 20) async throws -> [Story] {
        let endpoint = StoriesAPIEndpoint.getStories(page: page, pageSize: pageSize)
        return try await apiClient.request(endpoint, mapper: mapper)
    }
}

