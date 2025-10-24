//
//  StoryTests.swift
//  DomainTests
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Testing
import Foundation
@testable import Domain
@testable import DomainData
@testable import DomainDataMock
@testable import Networking

@Suite("Story Tests")
struct StoryTests {
    
    @Test("StoryDTO decodes correctly from JSON")
    func storyDTODecoding() throws {
        let json = """
        {
            "story_id": 1,
            "user_id": 100,
            "user_name": "Jessica",
            "user_profile_image_url": "https://i.pravatar.cc/300?img=1",
            "media_url": "https://picsum.photos/id/237/1080/1920",
            "created_at": "2025-10-24T10:30:00Z",
            "duration": 5.0
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let dto = try decoder.decode(StoryDTO.self, from: json)
        
        #expect(dto.storyId == 1)
        #expect(dto.userId == 100)
        #expect(dto.userName == "Jessica")
        #expect(dto.userProfileImageUrl == "https://i.pravatar.cc/300?img=1")
        #expect(dto.mediaUrl == "https://picsum.photos/id/237/1080/1920")
        #expect(dto.createdAt == "2025-10-24T10:30:00Z")
        #expect(dto.duration == 5.0)
    }
    
    @Test("Mapper converts StoryDTO to Story domain model")
    func storyMapper() throws {
        let dto = StoryDTO(
            storyId: 1,
            userId: 100,
            userName: "Jessica",
            userProfileImageUrl: "https://i.pravatar.cc/300?img=1",
            mediaUrl: "https://picsum.photos/id/237/1080/1920",
            createdAt: "2025-10-24T10:30:00Z",
            duration: 5.0
        )
        
        let mapper = StoryMapper()
        let story = try mapper.map(dto)
        
        #expect(story.id == 1)
        #expect(story.userId == 100)
        #expect(story.userName == "Jessica")
        #expect(story.userProfileImageURL?.absoluteString == "https://i.pravatar.cc/300?img=1")
        #expect(story.mediaURL?.absoluteString == "https://picsum.photos/id/237/1080/1920")
        #expect(story.duration == 5.0)
    }
    
    @Test("StoriesMapper converts array of DTOs")
    func storiesMapper() throws {
        let dtos = [
            StoryDTO(
                storyId: 1,
                userId: 100,
                userName: "Jessica",
                userProfileImageUrl: "https://i.pravatar.cc/300?img=1",
                mediaUrl: "https://picsum.photos/id/237/1080/1920",
                createdAt: "2025-10-24T10:30:00Z",
                duration: 5.0
            ),
            StoryDTO(
                storyId: 2,
                userId: 101,
                userName: "Krystina",
                userProfileImageUrl: "https://i.pravatar.cc/300?img=5",
                mediaUrl: "https://picsum.photos/id/1025/1080/1920",
                createdAt: "2025-10-24T11:15:00Z",
                duration: 7.0
            )
        ]
        
        let mapper = StoriesMapper()
        let stories = try mapper.map(dtos)
        
        #expect(stories.count == 2)
        #expect(stories[0].id == 1)
        #expect(stories[1].id == 2)
    }
    
    @Test("Mock repository returns stories successfully")
    func mockStoriesRepositorySuccess() async throws {
        let repository = MockStoriesRemoteRepository(delay: 0)
        let stories = try await repository.fetchStories()
        
        #expect(!stories.isEmpty, "Mock repository should return stories")
        #expect(stories.count == 10, "Mock repository should return 10 stories from sample data")
        
        let firstStory = try #require(stories.first)
        #expect(firstStory.userName == "Jessica")
        #expect(firstStory.duration == 5.0)
    }
    
    @Test("Mock repository throws error when configured to fail")
    func mockStoriesRepositoryFailure() async throws {
        let repository = MockStoriesRemoteRepository(shouldFail: true, delay: 0)
        
        await #expect(throws: Error.self) {
            try await repository.fetchStories()
        }
    }
}

@Suite("Story Interaction Tests")
struct StoryInteractionTests {
    
    @Test("StoryInteraction initializes correctly")
    func storyInteractionInit() {
        let interaction = StoryInteraction(
            id: 1,
            isSeen: true,
            isLiked: false,
            lastSeenAt: Date()
        )
        
        #expect(interaction.id == 1)
        #expect(interaction.isSeen == true)
        #expect(interaction.isLiked == false)
        #expect(interaction.lastSeenAt != nil)
    }
    
    @Test("StoryInteraction storage mapper converts correctly")
    func storyInteractionStorageMapper() {
        let mapper = StoryInteractionStorageMapper()
        let date = Date()
        
        let interaction = StoryInteraction(
            id: 1,
            isSeen: true,
            isLiked: false,
            lastSeenAt: date
        )
        
        let dbModel = mapper.toDBModel(interaction)
        
        #expect(dbModel.storyId == 1)
        #expect(dbModel.isSeen == true)
        #expect(dbModel.isLiked == false)
        #expect(dbModel.lastSeenAt == date)
        
        let domainModel = mapper.toDomain(dbModel)
        
        #expect(domainModel.id == interaction.id)
        #expect(domainModel.isSeen == interaction.isSeen)
        #expect(domainModel.isLiked == interaction.isLiked)
        #expect(domainModel.lastSeenAt == interaction.lastSeenAt)
    }
}

@Suite("Story Mapper Edge Cases")
struct StoryMapperEdgeCaseTests {
    
    @Test("Mapper handles invalid URLs")
    func mapperWithInvalidURL() throws {
        let dto = StoryDTO(
            storyId: 1,
            userId: 100,
            userName: "Test",
            userProfileImageUrl: nil,
            mediaUrl: nil,
            createdAt: "2025-10-24T10:30:00Z",
            duration: 5.0
        )
        
        let mapper = StoryMapper()
        let story = try mapper.map(dto)
        
        #expect(story.userProfileImageURL == nil)
        #expect(story.mediaURL == nil)
    }
    
    @Test("Mapper handles invalid date format")
    func mapperWithInvalidDate() throws {
        let dto = StoryDTO(
            storyId: 1,
            userId: 100,
            userName: "Test",
            userProfileImageUrl: nil,
            mediaUrl: nil,
            createdAt: "invalid-date",
            duration: 5.0
        )
        
        let mapper = StoryMapper()
        let story = try mapper.map(dto)
        
        #expect(story.createdAt != nil)
    }
}

