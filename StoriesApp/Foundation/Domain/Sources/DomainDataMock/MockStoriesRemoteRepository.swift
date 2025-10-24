//
//  MockStoriesRemoteRepository.swift
//  DomainDataMock
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Domain
import DomainData

/// Mock implementation of StoriesRemoteRepository for testing and previews
public final actor MockStoriesRemoteRepository: StoriesRemoteRepositoryProtocol {
    private let shouldFail: Bool
    private let delay: TimeInterval
    private let randomErrorRate: Double
    
    public init(shouldFail: Bool = false, delay: TimeInterval = 0.5, randomErrorRate: Double = 0.25) {
        self.shouldFail = shouldFail
        self.delay = delay
        self.randomErrorRate = randomErrorRate
    }
    
    public func fetchStories(page: Int = 1, pageSize: Int = 20) async throws -> [Story] {
        // Simulate network delay
        try await Task.sleep(for: .seconds(delay))
        
        // Random error simulation
        if Double.random(in: 0...1) < randomErrorRate {
            throw NSError(domain: "MockStoriesRemoteRepository", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Network connection failed. Please try again."
            ])
        }
        
        if shouldFail {
            throw NSError(domain: "MockStoriesRemoteRepository", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Mock network error"
            ])
        }
        
        // Load mock data from JSON file
        guard let url = Bundle.module.url(forResource: "sample_stories", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            // Fallback to hardcoded mock data
            return Story.mockList
        }
        
        let decoder = JSONDecoder()
        let dtos = try decoder.decode([StoryDTO].self, from: data)
        let mapper = StoriesMapper()
        return try mapper.map(dtos)
    }
}

/// Static mock for immediate use in previews
extension MockStoriesRemoteRepository {
    @MainActor public static let preview = MockStoriesRemoteRepository(delay: 0)
}

/// Mock story list for fallback
extension Story {
    static let mockList: [Story] = [
        Story(
            id: 1,
            userId: 100,
            userName: "Jessica",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"),
            mediaURL: URL(string: "https://picsum.photos/id/237/1080/1920"),
            createdAt: Date(),
            duration: 5.0
        ),
        Story(
            id: 2,
            userId: 101,
            userName: "Krystina",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=5"),
            mediaURL: URL(string: "https://picsum.photos/id/1025/1080/1920"),
            createdAt: Date(),
            duration: 7.0
        ),
        Story(
            id: 3,
            userId: 102,
            userName: "Taty",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=9"),
            mediaURL: URL(string: "https://picsum.photos/id/1039/1080/1920"),
            createdAt: Date(),
            duration: 6.0
        ),
        Story(
            id: 4,
            userId: 103,
            userName: "Makeyouhot",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=10"),
            mediaURL: URL(string: "https://picsum.photos/id/1043/1080/1920"),
            createdAt: Date(),
            duration: 5.5
        ),
        Story(
            id: 5,
            userId: 104,
            userName: "Sarah",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=16"),
            mediaURL: URL(string: "https://picsum.photos/id/1059/1080/1920"),
            createdAt: Date(),
            duration: 8.0
        ),
        Story(
            id: 6,
            userId: 105,
            userName: "Megan",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=20"),
            mediaURL: URL(string: "https://picsum.photos/id/106/1080/1920"),
            createdAt: Date(),
            duration: 6.5
        ),
        Story(
            id: 7,
            userId: 106,
            userName: "Delilah",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=23"),
            mediaURL: URL(string: "https://picsum.photos/id/1074/1080/1920"),
            createdAt: Date(),
            duration: 7.5
        ),
        Story(
            id: 8,
            userId: 107,
            userName: "Lizzz",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=26"),
            mediaURL: URL(string: "https://picsum.photos/id/1084/1080/1920"),
            createdAt: Date(),
            duration: 5.0
        ),
        Story(
            id: 9,
            userId: 108,
            userName: "Nini",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=29"),
            mediaURL: URL(string: "https://picsum.photos/id/119/1080/1920"),
            createdAt: Date(),
            duration: 6.0
        ),
        Story(
            id: 10,
            userId: 109,
            userName: "Sugar",
            userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=32"),
            mediaURL: URL(string: "https://picsum.photos/id/129/1080/1920"),
            createdAt: Date(),
            duration: 7.0
        )
    ]
}

