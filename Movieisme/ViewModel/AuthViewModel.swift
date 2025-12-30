//
//  AuthViewModel.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 09/07/1447 AH.
//

import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""

    @Published var errorMessage: String?
    @Published var currentUser: User?

    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else { return }

        errorMessage = nil

        do {
            let url = URL(
                string: "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users"
            )!

            let data = try await APIClient.fetch(url)
            let decoded = try JSONDecoder().decode(UsersResponse.self, from: data)

            if let user = decoded.records
                .map({ $0.fields })
                .first(where: {
                    $0.email.lowercased() == email.lowercased()
                    && $0.password == password
                }) {

                currentUser = user
            } else {
                errorMessage = "Invalid email or password"
                
            }

        } catch {
            errorMessage = "Failed to login"
        }
        print(errorMessage)

    }
    
    var hasError: Bool {
        errorMessage != nil
    }

    func clearError() {
        errorMessage = nil
    }

}
