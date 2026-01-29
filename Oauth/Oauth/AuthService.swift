//
//  AuthService.swift
//  Oauth
//
//  Created by Adrian on 29/01/2026.
//

import Foundation

struct AuthService {
    private let baseURL = URL(string: "http://127.0.0.1:8000")!

    func perform(mode: AuthMode, email: String, password: String) async throws -> AuthResult {
        let endpoint: String
        switch mode {
        case .login:
            endpoint = "/auth/login"
        case .register:
            endpoint = "/auth/register"
        }

        var request = URLRequest(url: baseURL.appending(path: endpoint))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = AuthPayload(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(payload)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.invalidResponse
        }

        if (200..<300).contains(httpResponse.statusCode) {
            if mode == .login {
                let token = try JSONDecoder().decode(TokenResponse.self, from: data)
                return .token(token.token)
            }
            return .registered
        } else {
            if let message = try? JSONDecoder().decode(ErrorResponse.self, from: data).detail {
                throw AuthError.server(message)
            }
            throw AuthError.server("Server error: \(httpResponse.statusCode)")
        }
    }
}
