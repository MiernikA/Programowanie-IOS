//
//  AddProductView.swift
//  ServerApp
//
//  Created by Adrian on 09/01/2026.
//

import SwiftUI

struct AddProductView: View {

    @Environment(\.dismiss)
    private var dismiss

    @State private var name = ""
    @State private var price = ""
    @State private var categoryId = ""

    let onSave: () async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Product data") {
                    TextField("Name", text: $name)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Category ID", text: $categoryId)
                        .keyboardType(.numberPad)
                }

                Button("Add product") {
                    Task {
                        await save()
                    }
                }
                .disabled(!isValid)
            }
            .navigationTitle("Add product")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var isValid: Bool {
        !name.isEmpty &&
        Double(price) != nil &&
        Int(categoryId) != nil
    }

    private func save() async {
        let product = ProductDTO(
            id: Int.random(in: 1000...9999),
            name: name,
            price: Double(price)!,
            categoryId: Int(categoryId)!
        )

        do {
            try await APIService.shared.addProduct(product)
            await onSave()
            dismiss()
        } catch {
            print("❌ Error adding product:", error)
        }
    }
}
