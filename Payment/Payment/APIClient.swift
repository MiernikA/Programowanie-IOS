//
//  APIClient.swift
//  Payment
//
//  Created by Adrian on 29/01/2026.
//

import Foundation

final class APIClient {
    static let shared = APIClient()

    private let baseURL = URL(string: "http://localhost:8000")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func addProduct(_ product: ProductCreate) async throws -> Product {
        let url = baseURL.appendingPathComponent("products")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(product)

        let (data, response) = try await session.data(for: request)
        try validate(response)
        return try JSONDecoder().decode(Product.self, from: data)
    }

    func pay(for productId: UUID, card: CardData) async throws -> Payment {
        let url = baseURL.appendingPathComponent("pay").appendingPathComponent(productId.uuidString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(card)

        let (data, response) = try await session.data(for: request)
        try validate(response)
        return try JSONDecoder().decode(Payment.self, from: data)
    }

    func fetchPurchasedProducts() async throws -> [PurchasedProduct] {
        let url = baseURL.appendingPathComponent("products").appendingPathComponent("purchased")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await session.data(for: request)
        try validate(response)
        return try JSONDecoder().decode([PurchasedProduct].self, from: data)
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
