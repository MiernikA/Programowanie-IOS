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

    @State private var tasks = [
        Task(title: "Buy groceries", imageName: "groceries"),
        Task(title: "Learn SwiftUI", imageName: "swift"),
        Task(title: "Finish the assignment", imageName: "assignment"),
        Task(title: "Go to the gym", imageName: "gym"),
        Task(title: "Read a book", imageName: "book")
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks, id: \.title) { task in
                    HStack(spacing: 14) {

                        Image(task.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Text(task.title)
                            .font(.system(size: 17, weight: .medium))

                        Spacer()
                    }
                    .padding(.vertical, 6)
                }
                .onDelete(perform: deleteTask)
            }
            .listStyle(.plain)
            .navigationTitle("Task List")
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}
