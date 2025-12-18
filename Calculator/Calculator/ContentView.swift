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

    @State private var displayValue = "0"
    @State private var storedValue: Double? = nil
    @State private var isEnteringSecondNumber = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    Text(displayValue)
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
                                handleTap(title)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
    }

    private func handleTap(_ value: String) {
        switch value {
        case "AC":
            displayValue = "0"
            storedValue = nil
            isEnteringSecondNumber = false

        case "+":
            storedValue = Double(displayValue)
            isEnteringSecondNumber = true

        case "=":
            if let first = storedValue, let second = Double(displayValue) {
                displayValue = format(first + second)
                storedValue = nil
            }

        default:
            if value.rangeOfCharacter(from: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))) != nil {
                if isEnteringSecondNumber {
                    displayValue = value
                    isEnteringSecondNumber = false
                } else {
                    displayValue = displayValue == "0" ? value : displayValue + value
                }
            }
        }
    }

    private func format(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(value)
    }
}
