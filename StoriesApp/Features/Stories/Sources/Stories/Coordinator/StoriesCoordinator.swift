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
    case storyViewer(startIndex: Int, stories: [Story])
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
                case .storyViewer(let startIndex, let stories):
                    StoryViewerView(
                        dependencies: .init(
                            startIndex: startIndex,
                            stories: stories,
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
