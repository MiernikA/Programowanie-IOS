//
//  TaskView.swift
//  TaskList
//
//  Created by Adrian on 05/01/2026.
//

import SwiftUI

struct TaskView: View {
    let task: Task

    var body: some View {
        VStack(spacing: 24) {
            Image(task.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            Text(task.title)
                .font(.title)
        }
        .padding()
    }
}
