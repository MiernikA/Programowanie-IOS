//
//  LoggedInView.swift
//  Oauth
//
//  Created by Adrian on 29/01/2026.
//

import SwiftUI

struct LoggedInView: View {
    let token: String
    let onLogout: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("You are logged in")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)

            Text("Token")
                .font(.headline)
            Text(token)
                .font(.footnote)
                .textSelection(.enabled)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Button("Log out", action: onLogout)
                .buttonStyle(.bordered)

            Spacer()
        }
        .padding()
    }
}
