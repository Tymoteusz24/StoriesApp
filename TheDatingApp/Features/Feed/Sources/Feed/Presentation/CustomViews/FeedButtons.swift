//
//  FeedButtons.swift
//  Feed
//
//  Created by Tymoteusz Pasieka on 10/23/25.
//

import SwiftUI
import SystemDesign

struct FeedSmallButton: View {
    var iconImage: Image
    var name: String
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack(spacing: 4) {
                iconImage
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: Design.Buttons.smallHeight,
                           height: Design.Buttons.smallHeight)
                    .background(
                        Color.gray
                    )
                    .clipShape(.circle)
                
                Text(name)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

struct FeedLargeButton: View {
    var iconImage: Image
    var name: String
    var onTap: () -> Void = {}
    var gradientColors: [Color]
    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack(spacing: 4) {
                iconImage
                    .gradientForeground(colors: gradientColors)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: Design.Buttons.largeHeight - 8,
                           height: Design.Buttons.largeHeight - 8)
                    .background(
                        Color.white
                    )
                    .clipShape(.circle)
                    .padding(4)
                    .background(.gray.opacity(0.5))
                    .clipShape(.circle)
                
                Text(name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview("FeedSmallButton") {
    VStack {
        Spacer()
        FeedSmallButton(iconImage: Image(systemName: "xmark"), name: "Skip")
        FeedLargeButton(iconImage: Image(systemName: "heart.fill"), name: "Date", gradientColors: BrandColors.primaryGradientColors)
        FeedLargeButton(iconImage: Image(systemName: "flame.fill"), name: "Down", gradientColors: BrandColors.flameGradientColors)
        FeedSmallButton(iconImage: Image(systemName: "bubble.fill"), name: "Flirt")
        
        Spacer()

    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.black)
}
