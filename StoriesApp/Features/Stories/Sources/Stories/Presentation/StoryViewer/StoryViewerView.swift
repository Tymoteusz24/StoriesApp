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
                Color.black.edgesIgnoringSafeArea(.all)
                
                // Story content
                TabView(selection: $viewModel.currentIndex) {
                    ForEach(viewModel.stories.indices, id: \.self) { index in
                        StoryContentView(story: viewModel.stories[index])
                            .tag(index)
                            .ignoresSafeArea(.all)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.all)
                .onChange(of: viewModel.currentIndex) { oldValue, newValue in
                    if oldValue != newValue {
                        viewModel.startAutoAdvance()
                        Task {
                            await viewModel.markCurrentAsSeen()
                        }
                    }
                }
                
                // Tap zones for navigation
                HStack(spacing: 0) {
                    // Left tap zone - previous story
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.previousStory()
                        }
                    
                    // Right tap zone - next story
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.nextStory()
                        }
                }
                
                // Overlays
                VStack(spacing: 0) {
                    // Progress bars
                    StoryProgressBar(
                        storyCount: viewModel.stories.count,
                        currentIndex: viewModel.currentIndex,
                        progress: viewModel.progress
                    )
                    
                    // Header
                    StoryHeaderView(
                        story: viewModel.currentStory,
                        onClose: {
                            router.navigateBack()
                        }
                    )
                    
                    Spacer()
                    
                    // Actions (like button)
                    StoryActionsView(
                        isLiked: viewModel.isLiked,
                        onLike: {
                            await viewModel.toggleLike()
                        }
                    )
                    .padding(.bottom, 40)
                }
            }
            .offset(y: dragOffset)
            .gesture(
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
            )
            .gesture(
                LongPressGesture(minimumDuration: 0.2)
                    .onChanged { _ in
                        viewModel.pause()
                    }
                    .onEnded { _ in
                        viewModel.resume()
                    }
            )
            .onTapGesture(count: 2) { location in
                Task {
                    await viewModel.toggleLike()
                }
            }
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

