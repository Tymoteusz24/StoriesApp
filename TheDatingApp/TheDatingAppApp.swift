//
//  TheDatingAppApp.swift
//  TheDatingApp
//
//  Created by Tymoteusz Pasieka on 10/22/25.
//

import SwiftUI
import SwiftData
import Logger

@main
struct TheDatingAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let logger = Logger(label: "TheDatingApp")
            logger.log(level: .debug, message: "app starts")
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
