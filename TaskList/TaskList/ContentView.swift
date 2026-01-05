//
//  ContentView.swift
//  TaskList
//
//  Created by Adrian on 05/01/2026.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    var isDone: Bool
}

struct ContentView: View {

    @State private var tasks = [
        Task(title: "Buy groceries", imageName: "groceries", isDone: false),
        Task(title: "Learn SwiftUI", imageName: "swift", isDone: false),
        Task(title: "Finish the assignment", imageName: "assignment", isDone: false),
        Task(title: "Go to the gym", imageName: "gym", isDone: false),
        Task(title: "Read a book", imageName: "book", isDone: false)
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach($tasks) { $task in
                    HStack(spacing: 16) {

                        Image(task.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .opacity(task.isDone ? 0.4 : 1)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.headline)
                                .strikethrough(task.isDone)
                                .foregroundColor(task.isDone ? .gray : .primary)

                            Text(task.isDone ? "Done" : "Not done")
                                .font(.caption)
                                .foregroundColor(task.isDone ? .green : .red)
                        }

                        Spacer()

                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(task.isDone ? .green : .gray)
                            .opacity(task.isDone ? 1 : 0)
                    }
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        task.isDone.toggle()
                    }
                }
                .onDelete(perform: deleteTask)
                .onMove(perform: moveTask)
            }
            .listStyle(.plain)
            .navigationTitle("Task List")
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    private func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
}
