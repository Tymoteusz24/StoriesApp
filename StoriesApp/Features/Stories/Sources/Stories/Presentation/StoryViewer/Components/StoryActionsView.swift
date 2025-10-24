//
//  StoryActionsView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI

struct StoryActionsView: View {
    let isLiked: Bool
    let onLike: () async -> Void
    
    @State private var showLikeAnimation = false
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 20) {
                // Like button
                Button(action: {
                    Task {
                        showLikeAnimation = true
                        await onLike()
                        try? await Task.sleep(for: .milliseconds(300))
                        showLikeAnimation = false
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 24))
                            .foregroundColor(isLiked ? .red : .white)
                    }
                }
                
                // Share button (placeholder)
                Button(action: {}) {
                    ZStack {
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "paperplane")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.trailing, 16)
        }
        .overlay(
            // Like animation overlay
            Group {
                if showLikeAnimation {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .scaleEffect(showLikeAnimation ? 1.2 : 0.5)
                        .opacity(showLikeAnimation ? 0 : 1)
                        .animation(.easeOut(duration: 0.5), value: showLikeAnimation)
                }
            }
        )
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        StoryActionsView(isLiked: false, onLike: {})
    }
}

