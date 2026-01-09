//
//  CategoriesListView.swift
//  ServerApp
//
//  Created by Adrian on 08/01/2026.
//

import SwiftUI
import CoreData

struct CategoriesListView: View {

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \CategoryEntity.name, ascending: true)
        ],
        animation: .default
    )
    private var categories: FetchedResults<CategoryEntity>

    var body: some View {
        NavigationStack {
            List(categories) { category in
                Text(category.name ?? "—")
                    .font(.headline)
                    .padding(.vertical, 4)
            }
            .navigationTitle("Categories")
        }
    }
}
