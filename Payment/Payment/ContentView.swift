//
//  ContentView.swift
//  Payment
//
//  Created by Adrian on 29/01/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PaymentViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.96, green: 0.97, blue: 0.99), Color(red: 0.89, green: 0.92, blue: 0.98)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        header
                        productPicker
                        cardPreview
                        paymentForm
                        paySection
                        purchasedList
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.seedProductsIfNeeded()
            }
        }
    }
}

#Preview {
    ContentView()
}

private extension ContentView {
    var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Complete your purchase")
                .font(.title2.weight(.semibold))
            Text("Secure payment powered by api.py")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 4)
    }

    var productPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Product")
                .font(.headline)

            if viewModel.products.isEmpty {
                Text("No products from api.py")
                    .foregroundStyle(.secondary)
            } else {
                Picker("Product", selection: $viewModel.selectedProductId) {
                    ForEach(viewModel.products) { product in
                        Text("\(product.name) - \(dollarAmount(product.price))")
                            .tag(Optional(product.id))
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
            }
        }
    }

    var cardPreview: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Debit / Credit")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("VISA")
                    .font(.subheadline.weight(.semibold))
            }

            Text(maskedCardNumber)
                .font(.title3.monospaced().weight(.medium))

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Card holder")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(cardHolderDisplay)
                        .font(.subheadline.weight(.medium))
                }
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expires")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(expiryDisplay)
                        .font(.subheadline.weight(.medium))
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color(red: 0.12, green: 0.14, blue: 0.2), Color(red: 0.22, green: 0.25, blue: 0.38)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
    }

    var paymentForm: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Payment details")
                .font(.headline)

            VStack(spacing: 12) {
                labeledField(title: "Card number") {
                    TextField("1234 5678 9012 3456", text: $viewModel.card.cardNumber)
                        .keyboardType(.numberPad)
                }

                labeledField(title: "Card holder") {
                    TextField("Jane Doe", text: $viewModel.card.cardHolder)
                        .textInputAutocapitalization(.words)
                }

                HStack(spacing: 12) {
                    labeledField(title: "Month") {
                        TextField("MM", value: $viewModel.card.expiryMonth, format: .number)
                            .keyboardType(.numberPad)
                    }
                    labeledField(title: "Year") {
                        TextField("YYYY", value: $viewModel.card.expiryYear, format: .number)
                            .keyboardType(.numberPad)
                    }
                    labeledField(title: "CVV") {
                        TextField("123", text: $viewModel.card.cvv)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .padding(16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 12, x: 0, y: 6)
        }
    }

    var paySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button {
                Task { await viewModel.pay() }
            } label: {
                HStack {
                    Text(viewModel.isBusy ? "Processing..." : "Pay now")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "lock.fill")
                }
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.13, green: 0.32, blue: 0.85))
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: .black.opacity(0.15), radius: 16, x: 0, y: 8)
            }
            .disabled(viewModel.isBusy)

            if let message = viewModel.message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(message == "Enter valid card details." ? .red : .secondary)
            }

            if let last = viewModel.payments.first {
                HStack {
                    Text("Last payment:")
                    Spacer()
                    Text(last.status == .success ? "SUCCESS" : "REJECTED")
                        .foregroundStyle(last.status == .success ? .green : .red)
                        .font(.subheadline.weight(.semibold))
                }
            }
        }
    }

    var purchasedList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Purchased products")
                    .font(.headline)
                Spacer()
                Button("Refresh") {
                    Task { await viewModel.refreshPurchased() }
                }
                .disabled(viewModel.isBusy)
            }

            if viewModel.purchasedProducts.isEmpty {
                Text("No paid products yet")
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 10) {
                    ForEach(viewModel.purchasedProducts) { product in
                        HStack {
                            Text(product.name)
                            Spacer()
                            Text(dollarAmount(product.price))
                                .foregroundStyle(.secondary)
                        }
                        .padding(12)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
            }
        }
    }

    func labeledField(title: String, field: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            field()
                .textFieldStyle(.plain)
                .padding(10)
                .background(Color(red: 0.95, green: 0.96, blue: 0.98))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }

    var maskedCardNumber: String {
        let digits = viewModel.card.cardNumber.filter { $0.isNumber }
        if digits.count >= 4 {
            let suffix = digits.suffix(4)
            return "**** **** **** \(suffix)"
        }
        return "**** **** **** 0000"
    }

    var cardHolderDisplay: String {
        let trimmed = viewModel.card.cardHolder.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "NAME SURNAME" : trimmed.uppercased()
    }

    var expiryDisplay: String {
        let month = String(format: "%02d", viewModel.card.expiryMonth)
        let year = String(viewModel.card.expiryYear).suffix(2)
        return "\(month)/\(year)"
    }

    func dollarAmount(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$\(String(format: "%.2f", value))"
    }
}
