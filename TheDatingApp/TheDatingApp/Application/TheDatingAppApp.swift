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

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        var profileService: UserProfileServiceProtocol = {
            let logger = NoLogger(label: "TheDatingApp")
            let apiClient = APIClientService (
                logger: logger,
                configuration: .default
            )
            return UserProfileRemoteRespository(apiClient: apiClient)
        }()

        do {
            let logger = Logger(label: "TheDatingApp")
            logger.log(level: .debug, message: "app starts")
            Task {
                let profiles = try? await profileService.fetchProfiles()
                print("profiles \(profiles ?? [])")
            }
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
