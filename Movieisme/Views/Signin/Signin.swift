//
//  Signin.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 03/07/1447 AH.
//

import SwiftUI

struct Signin: View {
    @StateObject private var authVM = AuthViewModel()

    var body: some View {
        NavigationStack {
            InputField(authVM: authVM)
                .background {
                    BackgroundImage()
                }
                .navigationDestination(isPresented: .constant(authVM.currentUser != nil)) {
                    MoviesCenterView()
                }
        }
    }
}

#Preview {
    Signin()
}
