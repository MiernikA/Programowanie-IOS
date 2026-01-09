//
//  ProductDto.swift
//  ServerApp
//
//  Created by Adrian on 07/01/2026.
//

struct ProductDTO: Codable {
    let id: Int
    let name: String
    let price: Double
    let categoryId: Int
}
