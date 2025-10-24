//
//  StoriesView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Router
import Domain
import DomainData
import DomainDataMock
import SystemDesign
import SDWebImageSwiftUI

struct StoriesView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: StoriesViewModel
    
    init(dependencies: StoriesViewModel.Depedencies) {
        _viewModel = StateObject(wrappedValue: StoriesViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.isLoadingInitial && viewModel.stories.isEmpty {
                    // Show shimmer loading state during initial load
                    ForEach(0..<5, id: \.self) { index in
                        StoryRowLoadingView()
                            .id("loading-\(index)")
                    }
                } else if let errorMessage = viewModel.errorMessage, viewModel.stories.isEmpty {
                    // Show error state
                    ErrorView(
                        message: errorMessage,
                        onRetry: {
                            Task {
                                await viewModel.loadInitialStories()
                            }
                        }
                    )
                    .padding(.top, 100)
                } else {
                    // Show actual stories
                    ForEach(viewModel.stories) { story in
                        Button(action: {
                            router.navigate(to: StoriesDestination.storyDetail(story))
                        }) {
                            StoryRowView(
                                story: story,
                                isSeen: viewModel.isSeen(story),
                                isLiked: viewModel.isLiked(story)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .id("story-\(story.id)")
                        .onAppear {
                            if story.id == viewModel.stories.last?.id {
                                Task {
                                    await viewModel.loadMoreStories()
                                }
                            }
                        }
                    }
                    
                    // Loading indicator at the bottom for pagination
                    if viewModel.isLoadingMore {
                        ForEach(0..<3, id: \.self) { index in
                            StoryRowLoadingView()
                                .id("pagination-loading-\(index)")
                        }
                    }
                    
                    // Show error toast for pagination errors
                    if let errorMessage = viewModel.errorMessage, !viewModel.stories.isEmpty {
                        ErrorToastView(
                            message: errorMessage,
                            onRetry: {
                                Task {
                                    await viewModel.loadMoreStories()
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, Design.Spacing.default)
            .padding(.vertical, Design.Spacing.default)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isLoadingInitial)
            .animation(.easeInOut(duration: 0.3), value: viewModel.stories.count)
        }
        .background(Color.black)
        .task {
            await viewModel.loadInitialStories()
        }
    }
}



#Preview("Loading State") {
    StoriesViewPreview(state: .loading)
}

#Preview("Success with Stories") {
    StoriesViewPreview(state: .success)
}

#Preview("Empty Error State") {
    StoriesViewPreview(state: .error)
}

#Preview("Pagination Loading") {
    StoriesViewPreview(state: .paginationLoading)
}

#Preview("Pagination Error") {
    StoriesViewPreview(state: .paginationError)
}

// MARK: - Preview Helper

fileprivate struct StoriesViewPreview: View {
    enum PreviewState {
        case loading
        case success
        case error
        case paginationLoading
        case paginationError
    }
    
    let state: PreviewState
    @StateObject private var mockViewModel: MockStoriesViewModel
    
    init(state: PreviewState) {
        self.state = state
        _mockViewModel = StateObject(wrappedValue: MockStoriesViewModel(state: state))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if mockViewModel.isLoadingInitial && mockViewModel.stories.isEmpty {
                    ForEach(0..<5, id: \.self) { index in
                        StoryRowLoadingView()
                            .id("loading-\(index)")
                    }
                } else if let errorMessage = mockViewModel.errorMessage, mockViewModel.stories.isEmpty {
                    ErrorView(
                        message: errorMessage,
                        onRetry: {}
                    )
                    .padding(.top, 100)
                } else {
                    ForEach(mockViewModel.stories) { story in
                        StoryRowView(
                            story: story,
                            isSeen: mockViewModel.isSeen(story),
                            isLiked: mockViewModel.isLiked(story)
                        )
                        .id("story-\(story.id)")
                    }
                    
                    if mockViewModel.isLoadingMore {
                        ForEach(0..<3, id: \.self) { index in
                            StoryRowLoadingView()
                                .id("pagination-loading-\(index)")
                        }
                    }
                    
                    if let errorMessage = mockViewModel.errorMessage, !mockViewModel.stories.isEmpty {
                        ErrorToastView(message: errorMessage, onRetry: {})
                    }
                }
            }
            .padding(.horizontal, Design.Spacing.default)
            .padding(.vertical, Design.Spacing.default)
        }
        .background(Color.black)
    }
}

fileprivate class MockStoriesViewModel: ObservableObject {
    @Published var stories: [Story] = []
    @Published var interactions: [Int: StoryInteraction] = [:]
    @Published var isLoadingMore: Bool = false
    @Published var isLoadingInitial: Bool = false
    @Published var errorMessage: String?
    
    init(state: StoriesViewPreview.PreviewState) {
        switch state {
        case .loading:
            isLoadingInitial = true
            
        case .success:
            stories = [
                Story(id: 1, userId: 100, userName: "Jessica", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"), mediaURL: URL(string: "https://picsum.photos/id/237/1080/1920"), createdAt: Date(), duration: 5.0),
                Story(id: 2, userId: 101, userName: "Krystina", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=5"), mediaURL: URL(string: "https://picsum.photos/id/1025/1080/1920"), createdAt: Date(), duration: 7.0),
                Story(id: 3, userId: 102, userName: "Taty", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=9"), mediaURL: URL(string: "https://picsum.photos/id/1039/1080/1920"), createdAt: Date(), duration: 6.0),
                Story(id: 4, userId: 103, userName: "Makeyouhot", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=10"), mediaURL: URL(string: "https://picsum.photos/id/1043/1080/1920"), createdAt: Date(), duration: 5.5),
                Story(id: 5, userId: 104, userName: "Sarah", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=16"), mediaURL: URL(string: "https://picsum.photos/id/1059/1080/1920"), createdAt: Date(), duration: 8.0)
            ]
            interactions = [
                1: StoryInteraction(id: 1, isSeen: true, isLiked: false, lastSeenAt: Date()),
                3: StoryInteraction(id: 3, isSeen: true, isLiked: true, lastSeenAt: Date())
            ]
            
        case .error:
            errorMessage = "Network connection failed. Please try again."
            
        case .paginationLoading:
            stories = [
                Story(id: 1, userId: 100, userName: "Jessica", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"), mediaURL: URL(string: "https://picsum.photos/id/237/1080/1920"), createdAt: Date(), duration: 5.0),
                Story(id: 2, userId: 101, userName: "Krystina", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=5"), mediaURL: URL(string: "https://picsum.photos/id/1025/1080/1920"), createdAt: Date(), duration: 7.0),
                Story(id: 3, userId: 102, userName: "Taty", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=9"), mediaURL: URL(string: "https://picsum.photos/id/1039/1080/1920"), createdAt: Date(), duration: 6.0)
            ]
            isLoadingMore = true
            
        case .paginationError:
            stories = [
                Story(id: 1, userId: 100, userName: "Jessica", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"), mediaURL: URL(string: "https://picsum.photos/id/237/1080/1920"), createdAt: Date(), duration: 5.0),
                Story(id: 2, userId: 101, userName: "Krystina", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=5"), mediaURL: URL(string: "https://picsum.photos/id/1025/1080/1920"), createdAt: Date(), duration: 7.0),
                Story(id: 3, userId: 102, userName: "Taty", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=9"), mediaURL: URL(string: "https://picsum.photos/id/1039/1080/1920"), createdAt: Date(), duration: 6.0)
            ]
            errorMessage = "Failed to load more stories."
        }
    }
    
    func isSeen(_ story: Story) -> Bool {
        interactions[story.id]?.isSeen ?? false
    }
    
    func isLiked(_ story: Story) -> Bool {
        interactions[story.id]?.isLiked ?? false
    }
}
