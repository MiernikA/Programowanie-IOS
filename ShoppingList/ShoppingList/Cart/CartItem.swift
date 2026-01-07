//
//  CartItem.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import Foundation

struct CartItem: Identifiable {
    let id = UUID()
    let product: Product
    var quantity: Int
}
