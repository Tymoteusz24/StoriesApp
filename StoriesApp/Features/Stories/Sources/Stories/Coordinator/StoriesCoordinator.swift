//
//  StoriesCoordinator.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Domain
import Router

enum StoriesDestination: Hashable {
    case profileDetail(UserProfile)
}

public struct StoriesCoordinator: View {
    @EnvironmentObject
    private var router: Router
    private let depedencies: Depedencies
    
    public init(depedencies: Depedencies) {
        self.depedencies = depedencies
    }
    
    public var body: some View {
        StoriesView(dependencies: .init(userProfileService: depedencies.userProfileService))
    }
}

public extension StoriesCoordinator {
    struct Depedencies {
        let userProfileService: UserProfileSyncServiceProtocol
       public init(userProfileService: UserProfileSyncServiceProtocol) {
            self.userProfileService = userProfileService
       }
    }
}
