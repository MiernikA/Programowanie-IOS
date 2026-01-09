//
//  ProductsListView.swift
//  ServerApp
//
//  Created by Adrian on 08/01/2026.
//

import SwiftUI
import CoreData

struct ProductsListView: View {

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

                    Text("Category ID: \(product.categoryId)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Products")
        }
    }
}
