//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Adrian on 18/12/2025.
//

import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {
    @Published var displayValue = "0"

    private var storedValue: Double?
    private var isEnteringSecondNumber = false

    func handleTap(_ value: String) {
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
            if value.rangeOfCharacter(
                from: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
            ) != nil {
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
