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
        do {
            let newStories = try await storiesService.fetchInitialStories()
            stories = newStories
            await loadInteractions()
        } catch {
            print("Error loading stories: \(error)")
        }
    }
    
    func loadMoreStories() async {
        do {
            let newStories = try await storiesService.fetchNextPage()
            stories.append(contentsOf: newStories)
            await loadInteractions()
        } catch {
            print("Error loading more stories: \(error)")
        }
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
