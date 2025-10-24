//
//  StoriesTabCoordinator.swift
//  StoriesApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Router
import Stories
// import feature

struct StoriesTabCoordinator: View {
    
    @EnvironmentObject var configuration: Configuration
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
            StoriesCoordinator(depedencies: .init(userProfileService: configuration.userProfileService))
        }.environmentObject(router)
    }
}

#Preview {
    StoriesTabCoordinator()
}
