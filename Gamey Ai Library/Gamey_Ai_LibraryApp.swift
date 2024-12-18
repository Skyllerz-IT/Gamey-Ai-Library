//
//  Gamey_Ai_LibraryApp.swift
//  Gamey Ai Library
//
//  Created by Davide Picentino on 09/12/24.
//

import SwiftUI
import SwiftData

@main
struct Gamey_Ai_LibraryApp: App {
    @StateObject private var favouritesManager = FavouritesManager()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                        .environmentObject(favouritesManager)
        }
        .modelContainer(sharedModelContainer)
    }
}
