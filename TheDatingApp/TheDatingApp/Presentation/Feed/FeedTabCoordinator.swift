//
//  FeedTabCoordinator.swift
//  TheDatingApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Router
import Feed
// import feature

struct FeedTabCoordinator: View {
    
    @EnvironmentObject var configuration: Configuration
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            FeedCoordinator(depedencies: .init(userProfileService: configuration.userProfileService))
        }.environmentObject(router)
    }
}

#Preview {
    FeedTabCoordinator()
}
