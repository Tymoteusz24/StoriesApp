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
    
    @Published var currentStory: Story?
    @Published var progress: Double = 0.0
    @Published var isPaused: Bool = false
    @Published var isLoading: Bool = false
    @Published var interaction: StoryInteraction?
    @Published var nextStoryId: Int?
    @Published var previousStoryId: Int?
    
    private let storyId: Int
    private var autoAdvanceTask: Task<Void, Never>?
    
    // Callback when story completes
    var onStoryComplete: (() -> Void)?
    
    var isLiked: Bool {
        interaction?.isLiked ?? false
    }
    
    var isSeen: Bool {
        interaction?.isSeen ?? false
    }
    
    struct Dependencies {
        let storyId: Int
        let storiesService: StoriesServiceProtocol
    }
    
    init(dependencies: Dependencies) {
        self.storyId = dependencies.storyId
        self.storiesService = dependencies.storiesService
    }
    
    func startViewing() async {
        await loadStory()
        await loadInteraction()
        await loadNavigationIds()
        await markCurrentAsSeen()
        startAutoAdvance()
    }
    
    func loadStory() async {
        isLoading = true
        do {
            currentStory = try await storiesService.getStory(byId: storyId)
            print("✅ [StoryViewer] Loaded story \(storyId)")
        } catch {
            print("❌ [StoryViewer] Error loading story: \(error)")
        }
        isLoading = false
    }
    
    func loadInteraction() async {
        do {
            interaction = try await storiesService.getInteraction(forStoryId: storyId)
        } catch {
            print("❌ [StoryViewer] Error loading interaction: \(error)")
        }
    }
    
    func loadNavigationIds() async {
        do {
            nextStoryId = try await storiesService.getNextStoryId(after: storyId)
            previousStoryId = try await storiesService.getPreviousStoryId(before: storyId)
        } catch {
            print("❌ [StoryViewer] Error loading navigation IDs: \(error)")
        }
    }
    
    func startAutoAdvance() {
        stopAutoAdvance()
        
        guard let story = currentStory else { return }
        let duration = story.duration
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
                    
                    // Clamp progress to 1.0 max to avoid warning
                    if self.progress >= 1.0 {
                        self.progress = 1.0
                        
                        // Notify completion and exit
                        self.onStoryComplete?()
                        return
                    }
                }
            }
            
            // If we complete the loop without hitting 1.0, set to 1.0 and complete
            if !Task.isCancelled {
                self.progress = 1.0
                self.onStoryComplete?()
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
    
    func toggleLike() async {
        guard let story = currentStory else { return }
        do {
            try await storiesService.toggleStoryLike(storyId: story.id)
            interaction = try? await storiesService.getInteraction(forStoryId: story.id)
            print("✅ [StoryViewer] Toggled like for story \(story.id)")
        } catch {
            print("❌ [StoryViewer] Error toggling like: \(error)")
        }
    }
    
    func markCurrentAsSeen() async {
        guard let story = currentStory else { return }
        do {
            try await storiesService.markStoryAsSeen(storyId: story.id)
            interaction = try? await storiesService.getInteraction(forStoryId: story.id)
            print("👁️ [StoryViewer] Marked story \(story.id) as seen")
        } catch {
            print("❌ [StoryViewer] Error marking as seen: \(error)")
        }
    }
    
    deinit {
        autoAdvanceTask?.cancel()
    }
}
