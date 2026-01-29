//
//  ContentView.swift
//  Oauth
//
//  Created by Adrian on 29/01/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var mode: AuthMode = .login
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var statusMessage = ""
    @State private var token = ""

    var body: some View {
        Group {
            if token.isEmpty {
                AuthFormView(
                    mode: $mode,
                    email: $email,
                    password: $password,
                    isLoading: $isLoading,
                    statusMessage: $statusMessage,
                    onSubmit: submit
                )
            } else {
                LoggedInView(token: token) {
                    token = ""
                    statusMessage = ""
                    email = ""
                    password = ""
                }
            }
        }
    }

    private func submit() {
        statusMessage = ""
        token = ""
        isLoading = true

        Task {
            do {
                let response = try await AuthService().perform(
                    mode: mode,
                    email: email,
                    password: password
                )
                switch response {
                case .registered:
                    statusMessage = "Account created. You can now log in."
                case .token(let value):
                    token = value
                    statusMessage = ""
                }
            } catch {
                statusMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

#Preview {
    ContentView()
}
