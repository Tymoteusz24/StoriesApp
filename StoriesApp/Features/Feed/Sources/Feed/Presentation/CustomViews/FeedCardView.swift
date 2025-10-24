//
//  SwiftUIView.swift
//  Feed
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Domain
import SystemDesign
import SDWebImageSwiftUI

struct FeedCardView: View {
    let profile: UserProfile?
    var body: some View {
        ZStack() {
            // Background image - fills entire card
            imageWithFradient
            
            // Text + buttons
            VStack {
                Spacer()
                textView
            }
            .padding(Design.Spacing.default)
            .padding(.bottom, Design.Buttons.largeHeight/2)
        }
        .background(Color.gray.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: Design.Card.cornerRadius))
        .shadow(radius: 5)
    }
}

extension FeedCardView {
    var imageWithFradient: some View {
        ZStack {
            // Background image - fills entire card
            GeometryReader { proxy in
                WebImage(url: profile?.profileImageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }
            // Gradient overlay for better text readability
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.9)]),
                startPoint: .center,
                endPoint: .bottom
            )
        }
    }
    
    var textView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let profile = profile {
                Text("\(profile.name), \(profile.age)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // bio
                Text(profile.bio)
                    .font(.body)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack {
        FeedCardView(profile: .mock)
            .padding(.vertical, 50)
            .padding(.horizontal, Design.Spacing.default)
    }
}
