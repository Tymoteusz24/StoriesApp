//
//  StoryDetailViewModel.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Domain

@MainActor
final class StoryDetailViewModel: ObservableObject {
    
    let story: Story
    let storiesService: StoriesServiceProtocol
    
    @Published var isLiked: Bool = false
    @Published var isSeen: Bool = false
    
    struct Dependencies {
        let story: Story
        let storiesService: StoriesServiceProtocol
    }
    
    init(dependencies: Dependencies) {
        self.story = dependencies.story
        self.storiesService = dependencies.storiesService
    }
    
    func loadInteraction() async {
        do {
            if let interaction = try await storiesService.getInteraction(forStoryId: story.id) {
                isLiked = interaction.isLiked
                isSeen = interaction.isSeen
            }
        } catch {
            print("Error loading interaction: \(error)")
        }
    }
    
    func markAsSeen() async {
        do {
            try await storiesService.markStoryAsSeen(storyId: story.id)
            isSeen = true
        } catch {
            print("Error marking as seen: \(error)")
        }
    }
    
    func toggleLike() async {
        do {
            try await storiesService.toggleStoryLike(storyId: story.id)
            isLiked.toggle()
        } catch {
            print("Error toggling like: \(error)")
        }
    }
}

