//
//  TheDatingAppApp.swift
//  TheDatingApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import SwiftData
import Logger
import DomainData
import Domain
import Networking

@main
struct TheDatingAppApp: App {
    
    let modelContainer: ModelContainer
    let configuration: Configuration
    
    init() {
        do {
            modelContainer = try ModelContainer(
                for: UserProfileDBModel.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        let logger = NoLogger(label: "TheDatingApp")
        
        let apiClient = APIClientService (
            logger: logger,
            configuration: .default
        )
        
        let userProfileService = UserProfileSyncService(
            apiClient: apiClient,
            modelContext: modelContainer.mainContext
        )
        Task {
            let profiles = try? await userProfileService.syncProfiles()
            print("Synced profiles count: \(profiles?.count ?? 0)")
        }
        self.configuration = Configuration(logger: logger,
                                           userProfileService: userProfileService)
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .environmentObject(configuration)
        .modelContainer(modelContainer)
    }
}
