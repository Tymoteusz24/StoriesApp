//
//  FeedCoordinator.swift
//  Feed
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import Domain
import Router

enum FeedDestination: Hashable {
    case profileDetail(UserProfile)
}

public struct FeedCoordinator: View {
    @EnvironmentObject
    private var router: Router
    private let depedencies: Depedencies
    
    public init(depedencies: Depedencies) {
        self.depedencies = depedencies
    }
    
    public var body: some View {
        FeedView(dependencies: .init())
    }
}

public extension FeedCoordinator {
    struct Depedencies {
       public init() { }
    }
}
