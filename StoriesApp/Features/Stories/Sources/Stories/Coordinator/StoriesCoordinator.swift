//
//  StoriesCoordinator.swift
//  Stories
//
//  Created by Tymoteusz Pasieka on 10/24/25.
//

import SwiftUI
import Domain
import Router

enum StoriesDestination: Hashable {
    case storyDetail(Story)
}

public struct StoriesCoordinator: View {
    @EnvironmentObject
    private var router: Router
    private let depedencies: Depedencies
    
    public init(depedencies: Depedencies) {
        self.depedencies = depedencies
    }
    
    public var body: some View {
        StoriesView(dependencies: .init(storiesService: depedencies.storiesService))
            .navigationDestination(for: StoriesDestination.self) { destination in
                switch destination {
                case .storyDetail(let story):
                    StoryDetailView(
                        dependencies: .init(
                            story: story,
                            storiesService: depedencies.storiesService
                        )
                    )
                }
            }
    }
}

public extension StoriesCoordinator {
    struct Depedencies {
        let storiesService: StoriesServiceProtocol
       public init(storiesService: StoriesServiceProtocol) {
            self.storiesService = storiesService
       }
    }
}
