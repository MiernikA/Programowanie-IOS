//
//  ContentView.swift
//  TaskList
//
//  Created by Adrian on 05/01/2026.
//

import SwiftUI

struct ContentView: View {
    private let tasks = [
        "Buy groceries",
        "Learn SwiftUI",
        "Finish the assignment",
        "Go to the gym",
        "Read a book"
    ]

    var body: some View {
        NavigationStack {
            List(tasks, id: \.self) { task in
                Text(task)
            }
            .navigationTitle("Tasks List")
        }
    }
}

#Preview {
    ContentView()
}

