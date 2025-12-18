//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Adrian on 18/12/2025.
//

import SwiftUI

struct ContentView: View {
    private let buttons: [String] = [
        "AC", "±", "%", "log",
        "7", "8", "9", "÷",
        "4", "5", "6", "×",
        "1", "2", "3", "−",
        "0", ".", "xʸ", "+",
        "", "", "", "="
    ]

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 4
    )

    @StateObject private var vm = CalculatorViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    Text(vm.displayValue)
                        .font(.system(size: 72, weight: .light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(buttons, id: \.self) { title in
                        if title.isEmpty {
                            Color.clear.frame(height: 72)
                        } else {
                            CalculatorButton(title: title) {
                                vm.handleTap(title)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }
}
