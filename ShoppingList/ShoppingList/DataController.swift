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

    init() {
        container = NSPersistentContainer(name: "ShoppingListModel")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data error: \(error)")
            }
        }

        loadFixtures()

    }

    private func loadFixtures() {
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
            category: food,
            context: context
        )

        createProduct(
            name: "Bread",
            price: 3.0,
            category: food,
            context: context
        )

        createProduct(
            name: "Milk",
            price: 2.8,
            category: food,
            context: context
        )

        createProduct(
            name: "Headphones",
            price: 199.0,
            category: electronics,
            context: context
        )

        createProduct(
            name: "Keyboard",
            price: 249.0,
            category: electronics,
            context: context
        )

        createProduct(
            name: "Mouse",
            price: 129.0,
            category: electronics,
            context: context
        )

        createProduct(
            name: "Dish Soap",
            price: 6.5,
            category: household,
            context: context
        )

        createProduct(
            name: "Paper Towels",
            price: 9.9,
            category: household,
            context: context
        )

        createProduct(
            name: "T-Shirt",
            price: 49.0,
            category: clothes,
            context: context
        )

        createProduct(
            name: "Jeans",
            price: 199.0,
            category: clothes,
            context: context
        )

        try? context.save()
    }

    private func createProduct(
        name: String,
        price: Double,
        category: Category,
        context: NSManagedObjectContext
    ) {
        let product = Product(context: context)
        product.id = UUID()
        product.name = name
        product.price = price
        product.category = category
    }
    
    
}

