//
//  FeedTabCoordinator.swift
//  TheDatingApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Router
// import feature

struct FeedTabCoordinator: View {
    
    @EnvironmentObject var configuration: Configuration
    @EnvironmentObject var router: Router
    
    var body: some View {
        NavigationStack(path: $router.navPath) {
           Text("Feed Tab Root View")
                .navigationTitle("Feed")
        }.environmentObject(router)
    }
}

#Preview {
    FeedTabCoordinator()
}
