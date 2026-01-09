//
//  ContentView.swift
//  ServerApp
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @Environment(\.managedObjectContext)
    private var context

    var body: some View {
        TabView {
            ProductsListView()
                .tabItem {
                    Text("Products")
                }

            CategoriesListView()
                .tabItem {
                    Text("Categories")
                }
        }
        .task {
            await loadAndSaveProducts()
            await loadAndSaveCategories()
        }
    }

    private func loadAndSaveProducts() async {
        do {
            let products = try await APIService.shared.fetchProducts()
            try saveProducts(products, context: context)
        } catch {
            print("Error:", error)
        }
    }

    private func loadAndSaveCategories() async {
        do {
            let categories = try await APIService.shared.fetchCategories()
            try saveCategories(categories, context: context)
        } catch {
            print("Error:", error)
        }
    }
}
