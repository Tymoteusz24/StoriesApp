//
//  FeedView.swift
//  Feed
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Router
import DomainData
import DomainDataMock
import SystemDesign

struct FeedView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: FeedViewModel
    
    init(dependencies: FeedViewModel.Depedencies) {
        _viewModel = StateObject(wrappedValue: FeedViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // top buttons
            topMenu
            
            FeedCardView(profile: viewModel.topProfile)
                .padding(.horizontal, Design.Spacing.default)
                .padding(.top, Design.Spacing.expanded)
            
            // feed card buttons
            feedCardButtons
                .padding(.top, -Design.Buttons.largeHeight/2)
                .padding(.bottom, Design.Spacing.default)
        }
        .background(.black)
        .task {
            await self.viewModel.getCurrentFeed()
        }
    }
}

extension FeedView {
    var topMenu: some View {
        ScrollView(.horizontal) {
            HStack {
                // 10 buttons
                ForEach(0..<10) { index in
                    Rectangle()
                        .fill(.red)
                        .frame(width: 150,
                               height: 50)
                }
            }
            .padding(.horizontal, Design.Spacing.default)
        }
        .scrollIndicators(.never)
    }
    
    var feedCardButtons: some View {
        HStack(spacing: Design.Spacing.expanded) {
            Spacer()
            FeedSmallButton(iconImage: Image(systemName: "xmark"), name: "Skip")
            FeedLargeButton(iconImage: Image(systemName: "heart.fill"), name: "Date", gradientColors: BrandColors.primaryGradientColors)
            FeedLargeButton(iconImage: Image(systemName: "flame.fill"), name: "Down", gradientColors: BrandColors.flameGradientColors)
            FeedSmallButton(iconImage: Image(systemName: "bubble.fill"), name: "Flirt")
            Spacer()
        }
        .padding(.horizontal, Design.Spacing.default)
    }
}
#Preview {
    TabView {
        FeedView(dependencies: .init(userProfileService: MockUserProfileSyncService.preview))
    }
    .background(.black)
    
}
