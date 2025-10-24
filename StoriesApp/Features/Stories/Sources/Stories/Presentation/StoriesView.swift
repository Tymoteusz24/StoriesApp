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
                ForEach(viewModel.stories) { story in
                    StoryRowView(
                        story: story,
                        isSeen: viewModel.isSeen(story),
                        isLiked: viewModel.isLiked(story)
                    )
                    .onAppear {
                        if story.id == viewModel.stories.last?.id {
                            Task {
                                await viewModel.loadMoreStories()
                            }
                        }
                    }
                }
                
                // Loading indicator at the bottom
                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.vertical, 20)
                }
            }
            .padding(.horizontal, Design.Spacing.default)
            .padding(.vertical, Design.Spacing.default)
        }
        .background(Color.black)
        .task {
            await viewModel.loadInitialStories()
        }
    }
}

struct StoryRowView: View {
    let story: Story
    let isSeen: Bool
    let isLiked: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            WebImage(url: story.userProfileImageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSeen ? Color.gray : Color.blue, lineWidth: 3)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(story.userName)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(Int(story.duration))s")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isLiked {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
            
            if isSeen {
                Image(systemName: "eye.fill")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview {
    Text("Preview placeholder")
}
