//
//  MockUserProfileService.swift
//  DomainDataMock
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Domain
import DomainData

/// Mock implementation of UserProfileService for testing and previews
public final actor MockUserProfileService: UserProfileServiceProtocol {
    private let shouldFail: Bool
    private let delay: TimeInterval
    
    public init(shouldFail: Bool = false, delay: TimeInterval = 0.5) {
        self.shouldFail = shouldFail
        self.delay = delay
    }
    
    public func fetchProfiles() async throws -> [UserProfile] {
        // Simulate network delay
        try await Task.sleep(for: .seconds(delay))
        
        if shouldFail {
            throw NSError(domain: "MockUserProfileService", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Mock network error"
            ])
        }
        
        // Load mock data from JSON file
        guard let url = Bundle.module.url(forResource: "sample_profiles", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            // Fallback to hardcoded mock data
            return UserProfile.mockList
        }
        
        let decoder = JSONDecoder()
        let dtos = try decoder.decode(UserProfilesDTO.self, from: data)
        let mapper = UserProfilesMapper()
        return try mapper.map(dtos)
    }
}

/// Static mock for immediate use in previews
extension MockUserProfileService {
    @MainActor public static let preview = MockUserProfileService(delay: 0)
}

