//
//  CartView.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI

struct CartView: View {

    @EnvironmentObject var cart: CartViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(cart.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.product.name ?? "")
                                .font(.headline)

                            Text("\(item.product.price, specifier: "%.2f") $")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        HStack {
                            Button("-") {
                                cart.decrease(item)
                            }

                            Text("\(item.quantity)")
                                .frame(minWidth: 24)

                            Button("+") {
                                cart.increase(item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cart")
        }
    }
}
