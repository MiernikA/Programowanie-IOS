//
//  PaymentViewModel.swift
//  Payment
//
//  Created by Adrian on 29/01/2026.
//

import Foundation
import Combine

@MainActor
final class PaymentViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedProducts: [PurchasedProduct] = []
    @Published var payments: [Payment] = []
    @Published var selectedProductId: UUID?
    @Published var card = CardData(
        cardNumber: "",
        cardHolder: "",
        expiryMonth: 1,
        expiryYear: 2026,
        cvv: ""
    )
    @Published var isBusy = false
    @Published var message: String?

    private let api: APIClient
    private var seeded = false

    init(api: APIClient = .shared) {
        self.api = api
    }

    func seedProductsIfNeeded() async {
        guard !seeded else { return }
        seeded = true
        isBusy = true
        message = nil

        do {
            var created: [Product] = []
            for seed in productSeeds {
                let product = try await api.addProduct(
                    ProductCreate(id: seed.id, name: seed.name, price: seed.price, currency: seed.currency)
                )
                created.append(product)
            }
            products = created
            selectedProductId = products.first?.id
            await refreshPurchased()
        } catch {
            message = "Cannot connect to api.py. Make sure the server is running at http://localhost:8000."
        }

        isBusy = false
    }

    func pay() async {
        guard let productId = selectedProductId else {
            message = "Select a product to pay for."
            return
        }

        guard isCardValid else {
            message = "Enter valid card details."
            return
        }

        isBusy = true
        message = nil

        do {
            let payment = try await api.pay(for: productId, card: card)
            payments.insert(payment, at: 0)
            message = payment.status == .success ? "Payment completed successfully." : "Payment rejected by mock server."
            await refreshPurchased()
        } catch {
            message = "Payment failed. Check your data and the api.py server."
        }

        isBusy = false
    }

    func refreshPurchased() async {
        do {
            let items = try await api.fetchPurchasedProducts()
            purchasedProducts = items
        } catch {
            message = "Failed to fetch purchased products."
        }
    }

    var isCardValid: Bool {
        let numberOK = card.cardNumber.count == 16
        let holderOK = !card.cardHolder.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let monthOK = (1...12).contains(card.expiryMonth)
        let yearOK = card.expiryYear >= 2024
        let cvvOK = card.cvv.count == 3
        return numberOK && holderOK && monthOK && yearOK && cvvOK
    }
}

private let productSeeds: [ProductSeed] = [
    ProductSeed(id: UUID(uuidString: "E8C13B48-7F6D-4DF6-A1B2-4D0D0F351A55")!, name: "Starter Pack", price: 19.99, currency: "USD"),
    ProductSeed(id: UUID(uuidString: "B7B06E5C-4A11-4E8B-9B9E-77F6D78F2E6C")!, name: "Pro Pack", price: 49.99, currency: "USD"),
    ProductSeed(id: UUID(uuidString: "C2C1A2C2-9BB9-46A8-8D94-3C2A1A28A3B3")!, name: "Premium Pack", price: 99.99, currency: "USD")
]
