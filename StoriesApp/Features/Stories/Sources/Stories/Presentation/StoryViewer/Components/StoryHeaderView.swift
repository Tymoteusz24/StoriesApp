//
//  StoryHeaderView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI
import Domain
import SDWebImageSwiftUI

struct StoryHeaderView: View {
    let story: Story
    let onClose: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            WebImage(url: story.userProfileImageURL)
                .resizable()
                .scaledToFill()
                .frame(width: 32, height: 32)
                .clipShape(Circle())
            
            Text(story.userName)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(timeAgoString(from: story.createdAt))
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.6), Color.clear],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    private func timeAgoString(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        
        if seconds < 60 {
            return "\(seconds)s"
        } else if seconds < 3600 {
            return "\(seconds / 60)m"
        } else if seconds < 86400 {
            return "\(seconds / 3600)h"
        } else {
            return "\(seconds / 86400)d"
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        VStack {
            StoryHeaderView(
                story: Story(
                    id: 1,
                    userId: 100,
                    userName: "Jessica",
                    userProfileImageURL: URL(string: "https://i.pravatar.cc/300?img=1"),
                    mediaURL: nil,
                    createdAt: Date().addingTimeInterval(-3600),
                    duration: 5.0
                ),
                onClose: {}
            )
            Spacer()
        }
    }
}

