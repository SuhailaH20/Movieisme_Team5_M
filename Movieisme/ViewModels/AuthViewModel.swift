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
            let formula = "AND(LOWER(email) = '\(email.lowercased())', password = '\(password)')"

            guard let encodedFormula = formula.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) else {
                errorMessage = "Invalid credentials format"
                return
            }

            let urlString = "https://api.airtable.com/v0/appsfcB6YESLj4NCN/users?filterByFormula=\(encodedFormula)"
            let url = URL(string: urlString)!

            let data = try await APIClient.fetch(url)
            let decoded = try JSONDecoder().decode(UsersResponse.self, from: data)

            if let record = decoded.records.first {
                currentUser = record.fields
            } else {
                errorMessage = "Invalid email or password"
            }

        } catch {
            errorMessage = "Failed to login"
        }
        print("error Message\(String(describing: errorMessage))")
    }
    
    var hasError: Bool {
        errorMessage != nil
    }

    func clearError() {
        errorMessage = nil
    }
}
