//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Adrian on 18/12/2025.
//

import Combine
import Foundation

final class CalculatorViewModel: ObservableObject {
    @Published var displayValue = "0"

    private var storedValue: Double?
    private var isEnteringSecondNumber = false
    private var currentOperation: Operation?

    enum Operation {
        case add, subtract, multiply, divide
    }

    func handleTap(_ value: String) {
        switch value {

        case "AC":
            reset()

        case "+":
            setOperation(.add)

        case "−":
            setOperation(.subtract)

        case "×":
            setOperation(.multiply)

        case "÷":
            setOperation(.divide)

        case "=":
            calculateResult()

        default:
            handleNumberInput(value)
        }
    }

    private func setOperation(_ operation: Operation) {
        storedValue = Double(displayValue)
        currentOperation = operation
        isEnteringSecondNumber = true
    }

    private func calculateResult() {
        guard
            let first = storedValue,
            let second = Double(displayValue),
            let operation = currentOperation
        else { return }

        let result: Double

        switch operation {
        case .add:
            result = first + second
        case .subtract:
            result = first - second
        case .multiply:
            result = first * second
        case .divide:
            result = second == 0 ? 0 : first / second
        }

        displayValue = format(result)
        reset(keepDisplay: true)
    }

    private func handleNumberInput(_ value: String) {
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

    private func reset(keepDisplay: Bool = false) {
        if !keepDisplay {
            displayValue = "0"
        }
        storedValue = nil
        currentOperation = nil
        isEnteringSecondNumber = false
    }

    private func format(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(value)
    }
}
