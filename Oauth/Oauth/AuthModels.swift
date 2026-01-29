//
//  AuthModels.swift
//  Oauth
//
//  Created by Adrian on 29/01/2026.
//

import Foundation

enum AuthMode: String, CaseIterable, Identifiable {
    case login = "Login"
    case register = "Register"

    var id: String { rawValue }
}

enum AuthResult {
    case registered
    case token(String)
}

struct AuthPayload: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Codable {
    let token: String
}

struct ErrorResponse: Codable {
    let detail: String
}

enum AuthError: LocalizedError {
    case invalidResponse
    case server(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .server(let message):
            return message
        }
    }
}
