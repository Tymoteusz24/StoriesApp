//
//  StoriesService.swift
//  DomainData
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Domain
import SwiftData

/// Service for managing stories with mock pagination.
///
/// This is a simplified implementation that provides infinite pagination by repeating
/// the base set of stories fetched from the API. Each paginated story receives a unique ID
/// to ensure proper SwiftUI list rendering and to allow independent tracking of seen/liked states.
///
/// **Mock Pagination Strategy:**
/// - Fetches base stories from the remote API once
/// - Repeats these stories infinitely across pages with modified IDs
/// - Maintains consistent `pageSize` for predictable pagination
/// - Each story gets a unique ID: `(page * pageSize) + index + 1`
///
/// **Example:**
/// If base stories have IDs [1, 2, 3] and pageSize = 20:
/// - Page 0: Stories with IDs 1-20 (repeating base stories)
/// - Page 1: Stories with IDs 21-40 (repeating base stories)
/// - Page 2: Stories with IDs 41-60 (repeating base stories)
/// - And so on...
///
/// **Note:** In a production environment, this would be replaced with real server-side pagination.
public actor StoriesService: StoriesServiceProtocol {
    private let remoteRepository: StoriesRemoteRepositoryProtocol
    private let localRepository: StoriesLocalRepository
    
    private var baseStories: [Story] = []
    private var currentPage = 0
    private let pageSize = 20
    
    public init(
        remoteRepository: StoriesRemoteRepositoryProtocol,
        localRepository: StoriesLocalRepository
    ) {
        self.remoteRepository = remoteRepository
        self.localRepository = localRepository
    }
    
    /// Fetches the initial page of stories (page 0).
    /// On first call, loads base stories from the remote API. Subsequent calls return cached data.
    public func fetchInitialStories() async throws -> [Story] {
        if baseStories.isEmpty {
            baseStories = try await remoteRepository.fetchStories(page: 1, pageSize: pageSize)
        }
        
        currentPage = 0
        return getPaginatedStories()
    }
    
    /// Fetches the next page of stories with unique IDs.
    /// Uses mock pagination by cycling through base stories with modified IDs.
    public func fetchNextPage() async throws -> [Story] {
        // Always call remote repository to simulate network request with potential errors
        _ = try await remoteRepository.fetchStories(page: currentPage + 1, pageSize: pageSize)
        
        // Use cached base stories for actual pagination
        if baseStories.isEmpty {
            baseStories = try await remoteRepository.fetchStories(page: 1, pageSize: pageSize)
        }
        
        currentPage += 1
        return getPaginatedStories()
    }
    
    public func getStoriesWithInteractions(stories: [Story]) async throws -> [(story: Story, interaction: StoryInteraction?)] {
        var result: [(story: Story, interaction: StoryInteraction?)] = []
        
        for story in stories {
            let interaction = try? await localRepository.getInteraction(forStoryId: story.id)
            result.append((story, interaction))
        }
        
        return result
    }
    
    public func markStoryAsSeen(storyId: Int) async throws {
        try await localRepository.markAsSeen(storyId: storyId)
    }
    
    public func toggleStoryLike(storyId: Int) async throws {
        try await localRepository.toggleLike(storyId: storyId)
    }
    
    public func getInteraction(forStoryId storyId: Int) async throws -> StoryInteraction? {
        return try await localRepository.getInteraction(forStoryId: storyId)
    }
    
    /// Generates paginated stories by repeating base stories with unique IDs.
    /// This is the core mock pagination logic that enables infinite scrolling.
    private func getPaginatedStories() -> [Story] {
        guard !baseStories.isEmpty else { return [] }
        
        let startIndex = currentPage * pageSize
        var paginatedStories: [Story] = []
        
        for i in 0..<pageSize {
            let baseIndex = (startIndex + i) % baseStories.count
            let originalStory = baseStories[baseIndex]
            
            let uniqueId = (currentPage * pageSize) + i + 1
            let story = Story(
                id: uniqueId,
                userId: originalStory.userId,
                userName: originalStory.userName,
                userProfileImageURL: originalStory.userProfileImageURL,
                mediaURL: originalStory.mediaURL,
                createdAt: originalStory.createdAt,
                duration: originalStory.duration
            )
            paginatedStories.append(story)
        }
        
        return paginatedStories
    }
}

