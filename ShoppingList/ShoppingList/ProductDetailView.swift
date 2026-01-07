//
//  ProductDetailView.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI

struct ProductDetailView: View {

    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(product.name ?? "")
                .font(.largeTitle)
                .bold()

            Text("Price: \(product.price, specifier: "%.2f") $")
                .font(.title3)

            Divider()

            Text(product.details ?? "No description available.")
                .font(.body)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
    }
}
