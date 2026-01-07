//
//  DataController.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI
import CoreData
import Combine

final class DataController: ObservableObject {

    let container: NSPersistentContainer
    private let fixturesKey = "didLoadFixtures"

    init() {
        container = NSPersistentContainer(name: "ShoppingListModel")

        if let description = container.persistentStoreDescriptions.first {
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data error: \(error)")
            }
        }

        loadFixtures()
    }

    private func loadFixtures() {
        if UserDefaults.standard.bool(forKey: fixturesKey) {
            return
        }

        let context = container.viewContext

        let food = Category(context: context)
        food.id = UUID()
        food.name = "Food"

        let electronics = Category(context: context)
        electronics.id = UUID()
        electronics.name = "Electronics"

        let household = Category(context: context)
        household.id = UUID()
        household.name = "Household"

        let clothes = Category(context: context)
        clothes.id = UUID()
        clothes.name = "Clothes"

        createProduct(
            name: "Apple",
            price: 2.5,
            details: "Fresh red apples, 1kg pack.",
            category: food,
            context: context
        )

        createProduct(
            name: "Bread",
            price: 3.0,
            details: "Wheat bread baked daily.",
            category: food,
            context: context
        )

        createProduct(
            name: "Milk",
            price: 2.8,
            details: "2% fat cow milk, 1 liter.",
            category: food,
            context: context
        )

        createProduct(
            name: "Headphones",
            price: 199.0,
            details: "Wireless headphones with noise cancelling.",
            category: electronics,
            context: context
        )

        createProduct(
            name: "Keyboard",
            price: 249.0,
            details: "Mechanical keyboard with RGB backlight.",
            category: electronics,
            context: context
        )

        createProduct(
            name: "Mouse",
            price: 129.0,
            details: "Wireless optical mouse.",
            category: electronics,
            context: context
        )

        createProduct(
            name: "Dish Soap",
            price: 6.5,
            details: "Lemon scented dishwashing liquid.",
            category: household,
            context: context
        )

        createProduct(
            name: "Paper Towels",
            price: 9.9,
            details: "Two-ply paper towels, 4 rolls.",
            category: household,
            context: context
        )

        createProduct(
            name: "T-Shirt",
            price: 49.0,
            details: "Cotton T-shirt, black, size M.",
            category: clothes,
            context: context
        )

        createProduct(
            name: "Jeans",
            price: 199.0,
            details: "Blue denim jeans, regular fit.",
            category: clothes,
            context: context
        )

        do {
            try context.save()
            UserDefaults.standard.set(true, forKey: fixturesKey)
        } catch {
            fatalError("Failed to save fixtures: \(error)")
        }
    }

    private func createProduct(
        name: String,
        price: Double,
        details: String,
        category: Category,
        context: NSManagedObjectContext
    ) {
        let product = Product(context: context)
        product.id = UUID()
        product.name = name
        product.price = price
        product.details = details
        product.category = category
    }
}
