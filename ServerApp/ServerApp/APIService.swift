//
//  APIService.swift
//  ServerApp
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI

final class APIService {
    
    static let shared = APIService()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:8000"
    
    func fetchProducts() async throws -> [ProductDTO] {
        let url = URL(string: "\(baseURL)/products")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([ProductDTO].self, from: data)
    }
    
    func fetchCategories() async throws -> [CategoryDTO] {
        let url = URL(string: "\(baseURL)/categories")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([CategoryDTO].self, from: data)
    }
    
    func addProduct(_ product: ProductDTO) async throws {
        let url = URL(string: "\(baseURL)/products")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(product)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    
}
