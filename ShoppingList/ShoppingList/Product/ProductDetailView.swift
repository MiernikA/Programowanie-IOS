//
//  ProductDetailView.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI

struct ProductDetailView: View {

    let product: Product
    @EnvironmentObject var cart: CartViewModel
    @State private var showAddedAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text(product.name ?? "")
                .font(.largeTitle)
                .bold()

            Text("Price: \(product.price, specifier: "%.2f") $")
                .font(.title3)

            Divider()

            Text(product.details ?? "No description available.")

            Button("Add to cart") {
                cart.add(product: product)
                showAddedAlert = true
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Details")
        .alert("Added to cart", isPresented: $showAddedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("\(product.name ?? "") has been added to the cart.")
        }
    }
}

