//
//  TestAssertions.swift
//  Test
//
//  Created by Adrian on 03/02/2025.
//

import Foundation

enum Pricing {
    static func applyDiscount(_ subtotal: Double, percent: Double) -> Double {
        let clamped = max(0.0, min(percent, 100.0))
        return subtotal * (1.0 - clamped / 100.0)
    }

    static func applyTax(_ amount: Double, rate: Double) -> Double {
        amount * (1.0 + rate)
    }

    static func roundToTwoDecimals(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }
}

enum ProductLogic {
    static func formattedPrice(_ price: Double) -> String {
        String(format: "$%.2f", price)
    }

    static func isInStock(_ product: Product) -> Bool {
        product.stock > 0
    }

    static func canAddToCart(_ product: Product) -> Bool {
        product.isAvailable && product.stock > 0
    }

    static func averageRating(_ products: [Product]) -> Double {
        guard !products.isEmpty else { return 0 }
        let total = products.reduce(0.0) { $0 + $1.rating }
        return total / Double(products.count)
    }

    static func normalizeSearch(_ text: String) -> String {
        let parts = text.lowercased().split { $0 == " " || $0 == "\n" || $0 == "\t" }
        return parts.joined(separator: " ")
    }

    static func matchesKeyword(_ product: Product, keyword: String) -> Bool {
        let needle = normalizeSearch(keyword)
        guard !needle.isEmpty else { return false }
        return product.name.lowercased().contains(needle)
    }
}

struct TestResult: Identifiable {
    let id = UUID()
    let name: String
    let passed: Bool
}

enum TestAssertions {
    static func runAll() -> [TestResult] {
        var results: [TestResult] = []
        results.append(contentsOf: runFunctional())
        results.append(contentsOf: runUnit())
        return results
    }

    private static func record(_ condition: Bool, _ name: String) -> TestResult {
        assert(condition, name)
        return TestResult(name: name, passed: condition)
    }

    private static func runFunctional() -> [TestResult] {
        var results: [TestResult] = []
        let products = MockData.products
        let categories = MockData.categories
        let active = categories.filter { $0.isActive }
        let inactive = categories.filter { !$0.isActive }

        results.append(record(active.count == 2, "Expected 2 active categories"))
        results.append(record(active.contains { $0.name == "Beverages" }, "Missing Beverages"))
        results.append(record(active.contains { $0.name == "Snacks" }, "Missing Snacks"))
        results.append(record(inactive.count == 1, "Expected 1 inactive category"))
        results.append(record(inactive.contains { $0.name == "Electronics" }, "Missing Electronics"))

        results.append(record(products.count == 6, "Expected 6 products"))
        results.append(record(MockData.products(in: MockData.beveragesId).count == 2, "Beverages count"))
        results.append(record(MockData.products(in: MockData.snacksId).count == 2, "Snacks count"))
        results.append(record(MockData.products(in: MockData.electronicsId).count == 2, "Electronics count"))

        let available = products.filter { $0.isAvailable }
        results.append(record(available.count == 5, "Expected 5 available products"))
        results.append(record(available.allSatisfy { $0.isAvailable }, "Availability mismatch"))

        let inStock = products.filter { $0.stock > 0 }
        let outOfStock = products.filter { $0.stock == 0 }
        results.append(record(inStock.count == 4, "Expected 4 in-stock items"))
        results.append(record(outOfStock.count == 2, "Expected 2 out-of-stock items"))

        let cart = products.filter { ["Coffee", "Chips", "Chocolate"].contains($0.name) }
        let subtotal = cart.reduce(0.0) { $0 + $1.price }
        results.append(record(abs(subtotal - 25.25) < 0.001, "Subtotal mismatch"))
        let discounted = Pricing.applyDiscount(subtotal, percent: 10)
        results.append(record(abs(discounted - 22.725) < 0.001, "Discount mismatch"))
        let taxed = Pricing.applyTax(discounted, rate: 0.08)
        results.append(record(abs(taxed - 24.543) < 0.001, "Tax mismatch"))
        let rounded = Pricing.roundToTwoDecimals(taxed)
        results.append(record(abs(rounded - 24.54) < 0.001, "Rounding mismatch"))

        let sortedByPrice = products.sorted { $0.price < $1.price }
        results.append(record(sortedByPrice.first?.name == "Chips", "Expected Chips first"))
        results.append(record(sortedByPrice.last?.name == "Headphones", "Expected Headphones last"))

        let search = products.filter { $0.name.lowercased().contains("ch") }
        results.append(record(search.count == 3, "Expected 3 results for 'ch'"))
        results.append(record(search.contains { $0.name == "Chips" }, "Search missing Chips"))
        results.append(record(search.contains { $0.name == "Chocolate" }, "Search missing Chocolate"))

        let grouped = Dictionary(grouping: products, by: { $0.categoryId })
        results.append(record(grouped.keys.count == 3, "Expected 3 groups"))
        results.append(record(grouped[MockData.beveragesId]?.count == 2, "Beverages group count"))
        results.append(record(grouped[MockData.snacksId]?.count == 2, "Snacks group count"))
        results.append(record(grouped[MockData.electronicsId]?.count == 2, "Electronics group count"))

        let range = products.filter { $0.price >= 6 && $0.price <= 15 }
        results.append(record(range.count == 3, "Range count mismatch"))
        results.append(record(range.map { $0.name }.sorted() == ["Chocolate", "Coffee", "Tea"], "Range names mismatch"))

        let topRated = products.max { $0.rating < $1.rating }
        results.append(record(topRated?.name == "Chocolate", "Top rated mismatch"))

        let titles = categories.map { "\($0.name) (\(MockData.products(in: $0.id).count))" }
        results.append(record(titles.contains("Beverages (2)"), "Missing Beverages title"))
        return results
    }

    private static func runUnit() -> [TestResult] {
        var results: [TestResult] = []
        let products = MockData.products
        let coffee = products.first { $0.name == "Coffee" }!
        let tea = products.first { $0.name == "Tea" }!
        let chips = products.first { $0.name == "Chips" }!

        results.append(record(abs(Pricing.applyDiscount(100, percent: 10) - 90) < 0.001, "Discount 10%"))
        results.append(record(abs(Pricing.applyDiscount(100, percent: 0) - 100) < 0.001, "Discount 0%"))
        results.append(record(abs(Pricing.applyDiscount(100, percent: 100) - 0) < 0.001, "Discount 100%"))
        results.append(record(abs(Pricing.applyDiscount(100, percent: 150) - 0) < 0.001, "Discount clamp high"))
        results.append(record(abs(Pricing.applyDiscount(100, percent: -10) - 100) < 0.001, "Discount clamp low"))

        results.append(record(abs(Pricing.applyTax(100, rate: 0.08) - 108) < 0.001, "Tax 8%"))
        results.append(record(abs(Pricing.applyTax(0, rate: 0.2) - 0) < 0.001, "Tax 0"))

        results.append(record(abs(Pricing.roundToTwoDecimals(1.235) - 1.24) < 0.001, "Round up"))
        results.append(record(abs(Pricing.roundToTwoDecimals(1.234) - 1.23) < 0.001, "Round down"))

        results.append(record(ProductLogic.formattedPrice(5) == "$5.00", "Format 5"))

        results.append(record(ProductLogic.isInStock(coffee) == true, "Coffee in stock"))
        results.append(record(ProductLogic.isInStock(tea) == false, "Tea out of stock"))

        results.append(record(ProductLogic.canAddToCart(coffee) == true, "Coffee can add"))
        results.append(record(ProductLogic.canAddToCart(tea) == false, "Tea cannot add"))

        results.append(record(ProductLogic.averageRating([]) == 0, "Average empty"))
        results.append(record(abs(ProductLogic.averageRating([coffee, tea]) - 4.35) < 0.001, "Average first two"))

        results.append(record(ProductLogic.normalizeSearch("  HeLLo  World ") == "hello world", "Normalize words"))
        results.append(record(ProductLogic.normalizeSearch("   \n\t  ") == "", "Normalize blanks"))

        results.append(record(ProductLogic.matchesKeyword(chips, keyword: "chi") == true, "Match keyword"))
        results.append(record(ProductLogic.matchesKeyword(chips, keyword: "") == false, "Empty keyword"))
        return results
    }
}
