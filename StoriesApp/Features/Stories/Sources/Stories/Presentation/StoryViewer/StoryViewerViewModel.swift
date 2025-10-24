//
//  StoryViewerViewModel.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import Foundation
import Domain
import Combine

@MainActor
final class StoryViewerViewModel: ObservableObject {
    
    let storiesService: StoriesServiceProtocol
    
    @Published var currentIndex: Int
    @Published var stories: [Story]
    @Published var progress: Double = 0.0
    @Published var isPaused: Bool = false
    @Published var interactions: [Int: StoryInteraction] = [:]
    
    private var autoAdvanceTask: Task<Void, Never>?
    
    var currentStory: Story {
        stories[currentIndex]
    }
    
    var isLiked: Bool {
        interactions[currentStory.id]?.isLiked ?? false
    }
    
    var isSeen: Bool {
        interactions[currentStory.id]?.isSeen ?? false
    }
    
    struct Dependencies {
        let startIndex: Int
        let stories: [Story]
        let storiesService: StoriesServiceProtocol
    }
    
    init(dependencies: Dependencies) {
        self.currentIndex = dependencies.startIndex
        self.stories = dependencies.stories
        self.storiesService = dependencies.storiesService
    }
    
    func startViewing() async {
        await loadInteractions()
        await markCurrentAsSeen()
        startAutoAdvance()
    }
    
    func startAutoAdvance() {
        stopAutoAdvance()
        
        let duration = currentStory.duration
        progress = 0.0
        
        autoAdvanceTask = Task { @MainActor [weak self] in
            guard let self = self else { return }
            
            let totalSteps = Int(duration * 100) // 100 updates per second for smooth animation
            let progressStep = 1.0 / Double(totalSteps)
            
            for _ in 0..<totalSteps {
                // Check if task was cancelled
                if Task.isCancelled {
                    return
                }
                
                // Wait for 0.01 seconds
                try? await Task.sleep(for: .milliseconds(10))
                
                // Update progress only if not paused
                if !self.isPaused {
                    self.progress += progressStep
                    
                    // Check if story completed
                    if self.progress >= 1.0 {
                        self.nextStory()
                        return
                    }
                }
            }
            
            // If we complete the loop, move to next story
            if !Task.isCancelled {
                self.nextStory()
            }
        }
    }
    
    func stopAutoAdvance() {
        autoAdvanceTask?.cancel()
        autoAdvanceTask = nil
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
    }
    
    func nextStory() {
        if currentIndex < stories.count - 1 {
            currentIndex += 1
            Task {
                await markCurrentAsSeen()
            }
            startAutoAdvance()
        } else {
            stopAutoAdvance()
        }
    }
    
    func previousStory() {
        if currentIndex > 0 {
            currentIndex -= 1
            startAutoAdvance()
        }
    }
    
    func toggleLike() async {
        do {
            try await storiesService.toggleStoryLike(storyId: currentStory.id)
            if let interaction = try? await storiesService.getInteraction(forStoryId: currentStory.id) {
                interactions[currentStory.id] = interaction
            }
            print("✅ [StoryViewer] Toggled like for story \(currentStory.id)")
        } catch {
            print("❌ [StoryViewer] Error toggling like: \(error)")
        }
    }
    
    func markCurrentAsSeen() async {
        do {
            try await storiesService.markStoryAsSeen(storyId: currentStory.id)
            if let interaction = try? await storiesService.getInteraction(forStoryId: currentStory.id) {
                interactions[currentStory.id] = interaction
            }
            print("👁️ [StoryViewer] Marked story \(currentStory.id) as seen")
        } catch {
            print("❌ [StoryViewer] Error marking as seen: \(error)")
        }
    }
    
    private func loadInteractions() async {
        for story in stories {
            if let interaction = try? await storiesService.getInteraction(forStoryId: story.id) {
                interactions[story.id] = interaction
            }
        }
    }
    
    deinit {
        autoAdvanceTask?.cancel()
    }
}
