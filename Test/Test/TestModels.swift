//
//  TestModels.swift
//  Test
//
//  Created by Adrian on 03/02/2025.
//

import Foundation

struct Product: Identifiable, Equatable {
    let id: UUID
    let name: String
    let price: Double
    let categoryId: UUID
    let isAvailable: Bool
    let rating: Double
    let stock: Int
}

struct Category: Identifiable, Equatable {
    let id: UUID
    let name: String
    let isActive: Bool
}

enum MockData {
    static let beveragesId = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
    static let snacksId = UUID(uuidString: "22222222-2222-2222-2222-222222222222")!
    static let electronicsId = UUID(uuidString: "33333333-3333-3333-3333-333333333333")!

    static let categories: [Category] = [
        Category(id: beveragesId, name: "Beverages", isActive: true),
        Category(id: snacksId, name: "Snacks", isActive: true),
        Category(id: electronicsId, name: "Electronics", isActive: false)
    ]

    static let products: [Product] = [
        Product(id: UUID(uuidString: "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa")!, name: "Coffee", price: 12.50, categoryId: beveragesId, isAvailable: true, rating: 4.5, stock: 10),
        Product(id: UUID(uuidString: "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb")!, name: "Tea", price: 8.00, categoryId: beveragesId, isAvailable: true, rating: 4.2, stock: 0),
        Product(id: UUID(uuidString: "cccccccc-cccc-cccc-cccc-cccccccccccc")!, name: "Chips", price: 5.50, categoryId: snacksId, isAvailable: true, rating: 3.9, stock: 25),
        Product(id: UUID(uuidString: "dddddddd-dddd-dddd-dddd-dddddddddddd")!, name: "Chocolate", price: 7.25, categoryId: snacksId, isAvailable: false, rating: 4.8, stock: 5),
        Product(id: UUID(uuidString: "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee")!, name: "Headphones", price: 199.99, categoryId: electronicsId, isAvailable: true, rating: 4.7, stock: 3),
        Product(id: UUID(uuidString: "ffffffff-ffff-ffff-ffff-ffffffffffff")!, name: "Charger", price: 29.99, categoryId: electronicsId, isAvailable: true, rating: 4.1, stock: 0)
    ]

    static func products(in categoryId: UUID) -> [Product] {
        products.filter { $0.categoryId == categoryId }
    }
}
