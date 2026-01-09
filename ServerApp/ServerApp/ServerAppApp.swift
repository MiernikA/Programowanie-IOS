//
//  ServerAppApp.swift
//  ServerApp
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI
import CoreData

@main
struct ServerAppApp: App {

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
        }
    }
}
