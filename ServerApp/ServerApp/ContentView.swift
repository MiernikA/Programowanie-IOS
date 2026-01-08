//
//  ContentView.swift
//  ServerApp
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        Text("Check console")
            .task {
                await loadData()
            }
    }

    private func loadData() async {
        do {
            let products = try await APIService.shared.fetchProducts()
            let categories = try await APIService.shared.fetchCategories()

            print("=== PRODUCTS ===")
            products.forEach { print($0) }

            print("=== CATEGORIES ===")
            categories.forEach { print($0) }

        } catch {
            print("❌ Error:", error)
        }
    }
}
