//
//  AuthFormView.swift
//  Oauth
//
//  Created by Adrian on 29/01/2026.
//

import SwiftUI

struct AuthFormView: View {
    @Binding var mode: AuthMode
    @Binding var email: String
    @Binding var password: String
    @Binding var isLoading: Bool
    @Binding var statusMessage: String
    let onSubmit: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Oauth")
                .font(.largeTitle.bold())

            Picker("Mode", selection: $mode) {
                ForEach(AuthMode.allCases) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.segmented)

            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textContentType(mode == .login ? .password : .newPassword)
                    .textFieldStyle(.roundedBorder)
            }

            Button(action: onSubmit) {
                HStack {
                    if isLoading {
                        ProgressView()
                    }
                    Text(mode == .login ? "Login" : "Register")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading || email.isEmpty || password.isEmpty)

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
    }
}
