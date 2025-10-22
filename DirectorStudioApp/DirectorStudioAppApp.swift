//
//  DirectorStudioAppApp.swift
//  DirectorStudioApp
//
//  Created by user944529 on 10/20/25.
//

import SwiftUI
import SwiftData
import DirectorStudioUI

@main
struct DirectorStudioAppApp: App {
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
            DirectorStudioContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
