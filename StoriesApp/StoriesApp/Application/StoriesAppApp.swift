//
//  StoriesAppApp.swift
//  StoriesApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import SwiftData
import Logger
import DomainData
import Domain
import Networking

// for now import stmock data
import DomainDataMock

@main
struct StoriesAppApp: App {
    
    let modelContainer: ModelContainer
    let configuration: Configuration
    
    init() {
        do {
            modelContainer = try ModelContainer(
                for: StoryInteractionDBModel.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        let logger = NoLogger(label: "StoriesApp")
    
// don't need api client now
//        let apiClient = APIClientService(
//            logger: logger,
//            configuration: .default
//        )
        
        let storiesRemoteRepository = MockStoriesRemoteRepository(delay: 1.5, randomErrorRate: 0.4)
        let storiesLocalRepository = StoriesLocalRepository(modelContext: modelContainer.mainContext)
        let storiesService = StoriesService(
            remoteRepository: storiesRemoteRepository,
            localRepository: storiesLocalRepository
        )
        
        self.configuration = Configuration(logger: logger, storiesService: storiesService)
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .environmentObject(configuration)
        .modelContainer(modelContainer)
    }
}
