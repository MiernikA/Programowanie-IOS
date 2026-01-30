//
//  Models.swift
//  Payment
//
//  Created by Adrian on 29/01/2026.
//

import Foundation

struct Product: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let price: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case currency
    }

    init(id: UUID, name: String, price: Double, currency: String) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        currency = (try? container.decode(String.self, forKey: .currency)) ?? "USD"
    }
}

struct ProductSeed: Identifiable {
    let id: UUID
    let name: String
    let price: Double
    let currency: String
}

struct ProductCreate: Codable {
    let id: UUID
    let name: String
    let price: Double
    let currency: String
}

enum PaymentStatus: String, Codable {
    case success
    case failed
}

struct Payment: Identifiable, Codable, Equatable {
    let id: UUID
    let productId: UUID
    let amount: Double
    let status: PaymentStatus

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case amount
        case status
    }
}

struct CardData: Codable, Equatable {
    var cardNumber: String
    var cardHolder: String
    var expiryMonth: Int
    var expiryYear: Int
    var cvv: String

    enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cardHolder = "card_holder"
        case expiryMonth = "expiry_month"
        case expiryYear = "expiry_year"
        case cvv
    }
}

struct PurchasedProduct: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let price: Double
    let currency: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case currency
    }

    init(id: UUID, name: String, price: Double, currency: String) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        currency = (try? container.decode(String.self, forKey: .currency)) ?? "USD"
    }
}
