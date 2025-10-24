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
                } else {
                    // Show actual stories
                    ForEach(viewModel.stories) { story in
                        StoryRowView(
                            story: story,
                            isSeen: viewModel.isSeen(story),
                            isLiked: viewModel.isLiked(story)
                        )
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



#Preview {
    Text("Preview placeholder")
}
