//
//  ShoppingListApp.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI

@main
struct ShoppingListApp: App {

    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              dataController.container.viewContext)
        }
    }
}
