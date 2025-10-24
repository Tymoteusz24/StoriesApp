//
//  StoryRowLoadingView.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI
import SystemDesign

struct StoryRowLoadingView: View {
    var body: some View {
        HStack(spacing: 12) {
            // Profile image placeholder
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 60)
                .shimmer()
            
            VStack(alignment: .leading, spacing: 8) {
                // Name placeholder
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 16)
                    .shimmer()
                
                // Duration placeholder
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 12)
                    .shimmer()
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(12)
    }
}

#Preview("Story Row Loading (Shimmer)") {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        VStack(spacing: 16) {
            StoryRowLoadingView()
            StoryRowLoadingView()
            StoryRowLoadingView()
            StoryRowLoadingView()
            StoryRowLoadingView()
        }
        .padding()
    }
}

