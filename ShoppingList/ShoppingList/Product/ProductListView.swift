//
//  ProductListView.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI
import CoreData

struct ProductListView: View {

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Product.name, ascending: true)
        ]
    )
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationStack {
            List(products) { product in
                NavigationLink {
                    ProductDetailView(product: product)
                } label: {
                    VStack(alignment: .leading) {
                        Text(product.name ?? "")
                            .font(.headline)

                        Text("\(product.price, specifier: "%.2f") $")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Products")
        }
    }
}
