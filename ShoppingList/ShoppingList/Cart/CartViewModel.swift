//
//  CartViewModel.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI
import Combine

final class CartViewModel: ObservableObject {

    @Published var items: [CartItem] = []

    func add(product: Product) {
        if let index = items.firstIndex(where: { $0.product.objectID == product.objectID }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
    }

    func increase(_ item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].quantity += 1
    }

    func decrease(_ item: CartItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }

        if items[index].quantity > 1 {
            items[index].quantity -= 1
        } else {
            items.remove(at: index)
        }
    }
}
