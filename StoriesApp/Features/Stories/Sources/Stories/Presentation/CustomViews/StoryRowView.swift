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