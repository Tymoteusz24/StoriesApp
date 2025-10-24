//
//  StoryViewerView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI
import Router
import Domain
import SystemDesign
import SDWebImageSwiftUI

struct StoryViewerView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: StoryViewerViewModel
    @GestureState private var dragOffset: CGFloat = 0
    
    init(dependencies: StoryViewerViewModel.Dependencies) {
        _viewModel = StateObject(wrappedValue: StoryViewerViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundLayer
                
                if viewModel.isLoading || viewModel.currentStory == nil {
                    loadingLayer
                } else {
                    storyContentLayer
                    navigationTapZonesLayer
                    overlayLayer
                }
            }
            .offset(y: dragOffset)
            .gesture(dismissSwipeGesture)
            .gesture(pauseGesture)
            .onTapGesture(count: 2, perform: handleDoubleTap)
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
        .task {
            // Set callback for auto-advance to next story
            viewModel.onStoryComplete = handleNext
            await viewModel.startViewing()
        }
        .onDisappear {
            viewModel.stopAutoAdvance()
        }
    }
    
    // MARK: - Layers
    
    private var backgroundLayer: some View {
        Color.black.edgesIgnoringSafeArea(.all)
    }
    
    private var loadingLayer: some View {
        ProgressView()
            .tint(.white)
            .scaleEffect(1.5)
    }
    
    private var storyContentLayer: some View {
        Group {
            if let story = viewModel.currentStory {
                StoryContentView(story: story)
            }
        }
    }
    
    private var navigationTapZonesLayer: some View {
        NavigationTapZones(
            onPrevious: handlePrevious,
            onNext: handleNext,
            hasPrevious: viewModel.previousStoryId != nil,
            hasNext: viewModel.nextStoryId != nil
        )
    }
    
    private var overlayLayer: some View {
        StoryOverlay(
            progress: viewModel.progress,
            currentStory: viewModel.currentStory,
            isLiked: viewModel.isLiked,
            onClose: handleClose,
            onLike: handleLike
        )
    }
    
    // MARK: - Gestures
    
    private var dismissSwipeGesture: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                if value.translation.height > 0 {
                    state = value.translation.height
                }
            }
            .onEnded { value in
                if value.translation.height > 100 {
                    // Swipe down dismisses entire story viewer
                    router.navigateToRoot()
                }
            }
    }
    
    private var pauseGesture: some Gesture {
        LongPressGesture(minimumDuration: 0.2)
            .onChanged { _ in
                viewModel.pause()
            }
            .onEnded { _ in
                viewModel.resume()
            }
    }
    
    // MARK: - Actions
    
    private func handlePrevious() {
        guard viewModel.previousStoryId != nil else { return }
        // Just go back in navigation stack
        router.navigateBack()
    }
    
    private func handleNext() {
        guard let nextId = viewModel.nextStoryId else {
            // No more stories, go back to list
            router.navigateToRoot()
            return
        }
        // Push next story onto navigation stack
        router.navigate(to: StoriesDestination.storyViewer(storyId: nextId))
    }
    
    private func handleClose() {
        // Dismiss entire story viewer and return to list
        router.navigateToRoot()
    }
    
    private func handleLike() async {
        await viewModel.toggleLike()
    }
    
    private func handleDoubleTap() {
        Task {
            await viewModel.toggleLike()
        }
    }
}

// MARK: - Navigation Tap Zones

private struct NavigationTapZones: View {
    let onPrevious: () -> Void
    let onNext: () -> Void
    let hasPrevious: Bool
    let hasNext: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            // Left tap zone - previous story
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    if hasPrevious {
                        onPrevious()
                    }
                }
            
            // Right tap zone - next story
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    onNext()  // Always allow tap - will close if no next story
                }
        }
    }
}

// MARK: - Story Overlay

private struct StoryOverlay: View {
    let progress: Double
    let currentStory: Story?
    let isLiked: Bool
    let onClose: () -> Void
    let onLike: () async -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Single progress bar for current story
            ProgressView(value: progress)
                .tint(.white)
                .padding(.horizontal, 8)
                .padding(.top, 8)
            
            if let story = currentStory {
                StoryHeaderView(
                    story: story,
                    onClose: onClose
                )
            }
            
            Spacer()
            
            StoryActionsView(
                isLiked: isLiked,
                onLike: onLike
            )
            .padding(.bottom, 40)
        }
    }
}

struct StoryContentView: View {
    let story: Story
    
    var body: some View {
        if let mediaURL = story.mediaURL {
            WebImage(url: mediaURL)
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea(.all)
        } else {
            ZStack {
                LinearGradient(
                    colors: [Color.purple, Color.blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack {
                    Text(story.userName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("No media available")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .ignoresSafeArea(.all)
        }
    }
}

#Preview {
    NavigationStack {
        StoryViewerView(
            dependencies: .init(
                storyId: 1,
                storiesService: PreviewStoriesService()
            )
        )
        .environmentObject(Router())
    }
}

fileprivate actor PreviewStoriesService: StoriesServiceProtocol {
    func fetchInitialStories() async throws -> [Story] { [] }
    func fetchNextPage() async throws -> [Story] { [] }
    func getStoriesWithInteractions(stories: [Story]) async throws -> [(story: Story, interaction: StoryInteraction?)] { [] }
    func markStoryAsSeen(storyId: Int) async throws {}
    func toggleStoryLike(storyId: Int) async throws {}
    func getInteraction(forStoryId storyId: Int) async throws -> StoryInteraction? { nil }
    func getStory(byId storyId: Int) async throws -> Story? {
        Story(id: storyId, userId: 100, userName: "Preview User", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"), mediaURL: URL(string: "https://picsum.photos/id/237/1080/1920"), createdAt: Date(), duration: 5.0)
    }
    func getNextStoryId(after storyId: Int) async throws -> Int? { storyId + 1 }
    func getPreviousStoryId(before storyId: Int) async throws -> Int? { storyId > 1 ? storyId - 1 : nil }
}

