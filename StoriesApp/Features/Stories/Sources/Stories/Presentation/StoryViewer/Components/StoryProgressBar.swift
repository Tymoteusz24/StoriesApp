//
//  StoryProgressBar.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI

struct StoryProgressBar: View {
    let storyCount: Int
    let currentIndex: Int
    let progress: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<storyCount, id: \.self) { index in
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                        
                        // Progress fill
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: progressWidth(for: index, totalWidth: geometry.size.width))
                    }
                }
                .frame(height: 2)
                .cornerRadius(1)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }
    
    private func progressWidth(for index: Int, totalWidth: CGFloat) -> CGFloat {
        if index < currentIndex {
            return totalWidth
        } else if index == currentIndex {
            return totalWidth * progress
        } else {
            return 0
        }
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        VStack {
            StoryProgressBar(storyCount: 5, currentIndex: 2, progress: 0.6)
            Spacer()
        }
    }
}

