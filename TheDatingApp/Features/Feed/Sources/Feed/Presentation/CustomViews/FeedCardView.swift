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
    let profile: UserProfile
    var body: some View {
        ZStack {
            HStack {
                WebImage(url: URL(string: profile.profileImageURL?.absoluteString ?? ""))
                    .resizable()
                    .indicator(.activity)
                    .scaledToFill()
                    .clipped()
            }
      
            Text("\(profile.name), \(profile.age)")
                .font(.title)
                .padding()
            Text(profile.bio)
                .font(.body)
                .padding([.leading, .trailing, .bottom])
        }
        .clipped()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

#Preview {
    FeedCardView(profile: .mock)
}
