//
//  RootTabView.swift
//  ShoppingList
//
//  Created by Adrian on 07/01/2026.
//

import SwiftUI

struct RootTabView: View {

    @StateObject private var cart = CartViewModel()

    var body: some View {
        TabView {
            ProductListView()
                .tabItem {
                    Label("Products", systemImage: "list.bullet")
                }

            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
        }
        .environmentObject(cart)
    }
}
