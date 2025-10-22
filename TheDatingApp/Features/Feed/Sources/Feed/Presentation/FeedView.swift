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

struct FeedView: View {
    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: FeedViewModel
    
    init(dependencies: FeedViewModel.Depedencies) {
        _viewModel = StateObject(wrappedValue: FeedViewModel(dependencies: dependencies))
    }
    
    var body: some View {
        VStack {
            if let topProfile = viewModel.topProfile {
                FeedCardView(profile: topProfile)
                
            }
           
        }
        .padding(.horizontal, 16)
        .task {
                await self.viewModel.getCurrentFeed()
            }
    }
}

#Preview {
    FeedView(dependencies: .init(userProfileService: MockUserProfileSyncService.preview))
}
