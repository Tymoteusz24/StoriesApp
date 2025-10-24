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
                storyPagerLayer
                navigationTapZonesLayer
                overlayLayer
            }
            .offset(y: dragOffset)
            .gesture(dismissSwipeGesture)
            .gesture(pauseGesture)
            .onTapGesture(count: 2, perform: handleDoubleTap)
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
        .task {
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
    
    private var storyPagerLayer: some View {
        StoryPager(
            stories: viewModel.stories,
            currentIndex: $viewModel.currentIndex,
            onIndexChanged: handleStoryIndexChanged
        )
    }
    
    private var navigationTapZonesLayer: some View {
        NavigationTapZones(
            onPrevious: viewModel.previousStory,
            onNext: viewModel.nextStory
        )
    }
    
    private var overlayLayer: some View {
        StoryOverlay(
            storyCount: viewModel.stories.count,
            currentIndex: viewModel.currentIndex,
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
                    router.navigateBack()
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
    
    private func handleStoryIndexChanged() {
        viewModel.startAutoAdvance()
        Task {
            await viewModel.markCurrentAsSeen()
        }
    }
    
    private func handleClose() {
        router.navigateBack()
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

// MARK: - Story Pager

private struct StoryPager: View {
    let stories: [Story]
    @Binding var currentIndex: Int
    let onIndexChanged: () -> Void
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(stories.indices, id: \.self) { index in
                StoryContentView(story: stories[index])
                    .tag(index)
                    .ignoresSafeArea(.all)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.all)
        .onChange(of: currentIndex) { oldValue, newValue in
            if oldValue != newValue {
                onIndexChanged()
            }
        }
    }
}

// MARK: - Navigation Tap Zones

private struct NavigationTapZones: View {
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(perform: onPrevious)
            
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture(perform: onNext)
        }
    }
}

// MARK: - Story Overlay

private struct StoryOverlay: View {
    let storyCount: Int
    let currentIndex: Int
    let progress: Double
    let currentStory: Story
    let isLiked: Bool
    let onClose: () -> Void
    let onLike: () async -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            StoryProgressBar(
                storyCount: storyCount,
                currentIndex: currentIndex,
                progress: progress
            )
            
            StoryHeaderView(
                story: currentStory,
                onClose: onClose
            )
            
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
                startIndex: 0,
                stories: [
                    Story(id: 1, userId: 100, userName: "Jessica", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"), mediaURL: URL(string: "https://picsum.photos/id/237/1080/1920"), createdAt: Date(), duration: 5.0),
                    Story(id: 2, userId: 101, userName: "Krystina", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=5"), mediaURL: URL(string: "https://picsum.photos/id/1025/1080/1920"), createdAt: Date(), duration: 7.0)
                ],
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
}

