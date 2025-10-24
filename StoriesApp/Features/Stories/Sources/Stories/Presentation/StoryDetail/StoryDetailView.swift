//
//  StoryDetailView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI
import Router
import Domain
import DomainDataMock
import SystemDesign

struct StoryDetailView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: StoryDetailViewModel
    
    init(dependencies: StoryDetailViewModel.Dependencies) {
        _viewModel = StateObject(wrappedValue: StoryDetailViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Story Detail")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                Text("Story ID: \(viewModel.story.id)")
                    .foregroundColor(.gray)
                
                Text("User: \(viewModel.story.userName)")
                    .foregroundColor(.white)
                    .padding(.top, 8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    NavigationStack {
        StoryDetailView(
            dependencies: .init(
                story: Story(
                    id: 1,
                    userId: 100,
                    userName: "Jessica",
                    userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"),
                    mediaURL: URL(string: "https://picsum.photos/id/237/1080/1920"),
                    createdAt: Date(),
                    duration: 5.0
                ),
                storiesService: PreviewStoriesService()
            )
        )
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

