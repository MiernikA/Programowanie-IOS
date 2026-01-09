//
//  PersistenceController.swift
//  ServerApp
//
//  Created by Adrian on 08/01/2026.
//

import CoreData

struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError(error.localizedDescription)
            }
        }
    }
}

