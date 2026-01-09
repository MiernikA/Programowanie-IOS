//
//  ProductsListView.swift
//  ServerApp
//
//  Created by Adrian on 08/01/2026.
//

import SwiftUI
import CoreData

struct ProductsListView: View {

    @Environment(\.managedObjectContext)
    private var context

    @State private var showAddProduct = false

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ProductEntity.name, ascending: true)
        ],
        animation: .default
    )
    private var products: FetchedResults<ProductEntity>

    var body: some View {
        NavigationStack {
            List(products) { product in
                VStack(alignment: .leading) {
                    Text(product.name ?? "—")
                        .font(.headline)
                    Text("Price: \(product.price)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddProduct = true
                    } label: {
                        Text("+")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showAddProduct) {
                AddProductView {
                    await reloadProducts()
                }
            }
        }
    }

    private func reloadProducts() async {
        do {
            let products = try await APIService.shared.fetchProducts()
            try saveProducts(products, context: context)
        } catch {
            print("❌ Reload error:", error)
        }
    }
}
