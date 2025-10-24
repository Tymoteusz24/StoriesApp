//
//  StoriesViewModel.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import Foundation
import Domain

@MainActor
final class StoriesViewModel: ObservableObject {
    
   let storiesService: StoriesServiceProtocol
    
    @Published var stories: [Story] = []
    @Published var interactions: [Int: StoryInteraction] = [:]
    @Published var isLoadingMore: Bool = false
    @Published var isLoadingInitial: Bool = false
    
    var topStory: Story? {
        stories.first
    }
    
    var nextStory: Story? {
        guard stories.count > 1 else {
            return nil
        }
        return stories[1]
    }
    
    struct Depedencies {
        let storiesService: StoriesServiceProtocol
    }
    
    init(dependencies: Depedencies) {
        self.storiesService = dependencies.storiesService
    }
    
    func loadInitialStories() async {
        isLoadingInitial = true
        print("📱 [StoriesViewModel] Loading initial stories...")
        do {
            let newStories = try await storiesService.fetchInitialStories()
            stories = newStories
            print("✅ [StoriesViewModel] Loaded \(newStories.count) stories")
            print("📋 [StoriesViewModel] Story IDs: \(newStories.prefix(5).map { $0.id })")
            await loadInteractions()
        } catch {
            print("❌ [StoriesViewModel] Error loading stories: \(error)")
        }
        isLoadingInitial = false
    }
    
    func loadMoreStories() async {
        guard !isLoadingMore else { return }
        
        isLoadingMore = true
        print("📱 [StoriesViewModel] Loading more stories... Current count: \(stories.count)")
        do {
            let newStories = try await storiesService.fetchNextPage()
            let previousCount = stories.count
            stories.append(contentsOf: newStories)
            print("✅ [StoriesViewModel] Loaded \(newStories.count) more stories. Total: \(stories.count)")
            print("📋 [StoriesViewModel] New story IDs: \(newStories.prefix(5).map { $0.id })")
            print("📊 [StoriesViewModel] Stories \(previousCount) → \(stories.count)")
            await loadInteractions()
        } catch {
            print("❌ [StoriesViewModel] Error loading more stories: \(error)")
        }
        isLoadingMore = false
    }
    
    func removeTopStory() {
        guard !stories.isEmpty else { return }
        stories.removeFirst()
    }
    
    func markStoryAsSeen(_ story: Story) async {
        do {
            try await storiesService.markStoryAsSeen(storyId: story.id)
            if let interaction = try? await storiesService.getInteraction(forStoryId: story.id) {
                interactions[story.id] = interaction
            }
        } catch {
            print("Error marking story as seen: \(error)")
        }
    }
    
    func toggleLike(_ story: Story) async {
        do {
            try await storiesService.toggleStoryLike(storyId: story.id)
            if let interaction = try? await storiesService.getInteraction(forStoryId: story.id) {
                interactions[story.id] = interaction
            }
        } catch {
            print("Error toggling like: \(error)")
        }
    }
    
    func isSeen(_ story: Story) -> Bool {
        interactions[story.id]?.isSeen ?? false
    }
    
    func isLiked(_ story: Story) -> Bool {
        interactions[story.id]?.isLiked ?? false
    }
    
    private func loadInteractions() async {
        for story in stories {
            if let interaction = try? await storiesService.getInteraction(forStoryId: story.id) {
                interactions[story.id] = interaction
            }
        }
    }
}
