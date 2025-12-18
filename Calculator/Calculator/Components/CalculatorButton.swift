//
//  CalculatorViewModel.swift
//  Calculator
//
//  Created by Adrian on 18/12/2025.
//


import SwiftUI

struct CalculatorButton: View {
    let title: String
    let action: () -> Void

    private var isWide: Bool {
        title == "0"
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .frame(
                    maxWidth: .infinity,
                    minHeight: 72,
                    maxHeight: 72
                )
                .background(buttonColor)
                .clipShape(RoundedRectangle(cornerRadius: 36))
        }
        .gridCellColumns(isWide ? 2 : 1)
    }

    private var buttonColor: Color {
        switch title {
        case "AC":
            return Color(red: 0.65, green: 0.22, blue: 0.20)
        case "+", "=":
            return Color(red: 0.12, green: 0.18, blue: 0.35)
        default:
            return Color(white: 0.2)
        }
    }
}
