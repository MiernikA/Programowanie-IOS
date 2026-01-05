//
//  ContentView.swift
//  TaskList
//
//  Created by Adrian on 05/01/2026.
//

import SwiftUI

struct Task {
    let title: String
    let imageName: String
}

struct ContentView: View {
    private let tasks = [
        Task(title: "Buy groceries", imageName: "groceries"),
        Task(title: "Learn SwiftUI", imageName: "swift"),
        Task(title: "Finish the assignment", imageName: "assignment"),
        Task(title: "Go to the gym", imageName: "gym"),
        Task(title: "Read a book", imageName: "book")
    ]

    var body: some View {
        NavigationStack {
            List(tasks, id: \.title) { task in
                HStack(spacing: 16) {
                    Image(task.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)

                    Text(task.title)
                        .font(.headline)

                    Spacer()
                }
                .padding(.vertical, 12)
                .listRowInsets(
                    EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                )
            }
            .listStyle(.plain)
            .navigationTitle("Task List")
        }
    }
}

