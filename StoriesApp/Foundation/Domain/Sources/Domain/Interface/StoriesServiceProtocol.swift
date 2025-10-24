//
//  StoriesServiceProtocol.swift
//  Domain
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation

public protocol StoriesServiceProtocol: Sendable {
    func fetchInitialStories() async throws -> [Story]
    func fetchNextPage() async throws -> [Story]
    func getStoriesWithInteractions(stories: [Story]) async throws -> [(story: Story, interaction: StoryInteraction?)]
    func markStoryAsSeen(storyId: Int) async throws
    func toggleStoryLike(storyId: Int) async throws
    func getInteraction(forStoryId storyId: Int) async throws -> StoryInteraction?
    
    // Single story navigation methods
    func getStory(byId storyId: Int) async throws -> Story?
    func getNextStoryId(after storyId: Int) async throws -> Int?
    func getPreviousStoryId(before storyId: Int) async throws -> Int?
}

