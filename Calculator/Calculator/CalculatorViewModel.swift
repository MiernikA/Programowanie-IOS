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
    private var currentOperation: Operation?
    private var isEnteringNewNumber = true

    enum Operation {
        case add, subtract, multiply, divide
    }

    func handleTap(_ value: String) {
        switch value {

        case "AC":
            reset()

        case "+":
            applyOperation(.add)

        case "−":
            applyOperation(.subtract)

        case "×":
            applyOperation(.multiply)

        case "÷":
            applyOperation(.divide)

        case "=":
            calculateIfPossible()
            currentOperation = nil

        default:
            handleNumberInput(value)
        }
    }


    private func applyOperation(_ newOperation: Operation) {
        calculateIfPossible()
        currentOperation = newOperation
        isEnteringNewNumber = true
    }

    private func calculateIfPossible() {
        guard
            let operation = currentOperation,
            let first = storedValue,
            let second = Double(displayValue)
        else {
            storedValue = Double(displayValue)
            return
        }

        let result = performOperation(first, second, operation)
        displayValue = format(result)
        storedValue = result
    }

    private func performOperation(
        _ a: Double,
        _ b: Double,
        _ operation: Operation
    ) -> Double {
        switch operation {
        case .add:
            return a + b
        case .subtract:
            return a - b
        case .multiply:
            return a * b
        case .divide:
            return b == 0 ? 0 : a / b
        }
    }

    private func handleNumberInput(_ value: String) {
        guard value.rangeOfCharacter(
            from: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
        ) != nil else { return }

        if isEnteringNewNumber {
            displayValue = value
            isEnteringNewNumber = false
        } else {
            displayValue = displayValue == "0"
                ? value
                : displayValue + value
        }
    }

    private func reset() {
        displayValue = "0"
        storedValue = nil
        currentOperation = nil
        isEnteringNewNumber = true
    }

    private func format(_ value: Double) -> String {
        value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(value)
    }
}
