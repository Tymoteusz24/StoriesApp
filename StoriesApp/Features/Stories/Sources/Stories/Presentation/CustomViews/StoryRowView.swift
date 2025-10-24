//
//  StoryRowView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//


import SwiftUI
import Router
import Domain
import DomainData
import DomainDataMock
import SystemDesign
import SDWebImageSwiftUI

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

#Preview("Story Row - Unseen") {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        StoryRowView(
            story: Story(
                id: 1,
                userId: 100,
                userName: "Jessica",
                userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"),
                mediaURL: URL(string: "https://picsum.photos/id/237/1080/1920"),
                createdAt: Date(),
                duration: 5.0
            ),
            isSeen: false,
            isLiked: false
        )
        .padding()
    }
}

#Preview("Story Row - Seen") {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        StoryRowView(
            story: Story(
                id: 2,
                userId: 101,
                userName: "Krystina",
                userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=5"),
                mediaURL: URL(string: "https://picsum.photos/id/1025/1080/1920"),
                createdAt: Date(),
                duration: 7.0
            ),
            isSeen: true,
            isLiked: false
        )
        .padding()
    }
}

#Preview("Story Row - Liked") {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        StoryRowView(
            story: Story(
                id: 3,
                userId: 102,
                userName: "Taty",
                userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=9"),
                mediaURL: URL(string: "https://picsum.photos/id/1039/1080/1920"),
                createdAt: Date(),
                duration: 6.0
            ),
            isSeen: true,
            isLiked: true
        )
        .padding()
    }
}

#Preview("Story Row - All States") {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        VStack(spacing: 16) {
            StoryRowView(
                story: Story(id: 1, userId: 100, userName: "Jessica", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"), mediaURL: nil, createdAt: Date(), duration: 5.0),
                isSeen: false,
                isLiked: false
            )
            
            StoryRowView(
                story: Story(id: 2, userId: 101, userName: "Krystina", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=5"), mediaURL: nil, createdAt: Date(), duration: 7.0),
                isSeen: true,
                isLiked: false
            )
            
            StoryRowView(
                story: Story(id: 3, userId: 102, userName: "Taty", userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=9"), mediaURL: nil, createdAt: Date(), duration: 6.0),
                isSeen: true,
                isLiked: true
            )
        }
        .padding()
    }
}