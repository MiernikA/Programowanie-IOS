//
//  ContentView.swift
//  Test
//
//  Created by Adrian on 03/02/2025.
//

import SwiftUI

struct ContentView: View {
    private let categories = MockData.categories
    private let products = MockData.products
    @State private var results: [TestResult] = []

    var body: some View {
        NavigationStack {
            List {
                Section("Test Results") {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(results) { result in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(result.passed ? Color.green : Color.red)
                                    .frame(width: 8, height: 8)
                                Text(result.name)
                                    .font(.subheadline)
                                Spacer()
                                Text(result.passed ? "OK" : "FAIL")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section("Categories") {
                    ForEach(categories) { category in
                        let count = MockData.products(in: category.id).count
                        HStack {
                            Text(category.name)
                            Spacer()
                            Text("\(count)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Products") {
                    ForEach(products) { product in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.name)
                                Text(ProductLogic.formattedPrice(product.price))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(ProductLogic.isInStock(product) ? "In stock" : "Out")
                                .font(.caption)
                                .foregroundStyle(ProductLogic.isInStock(product) ? .green : .red)
                        }
                    }
                }
            }
            .navigationTitle("Test Shop")
        }
        .onAppear { results = TestAssertions.runAll() }
    }
}

#Preview {
    ContentView()
}
