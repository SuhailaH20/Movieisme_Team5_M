//
//  ContentView.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 03/07/1447 AH.
//

import SwiftUI

struct SigninPage: View {
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


struct BackgroundImage: View {
    var body: some View {
        Image("Signinbackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(1.9), Color.clear]),
            startPoint: .bottom, endPoint: .top
        ).ignoresSafeArea()
    }
}


struct InputField: View {
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()

            Text("Sign in")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                

            Text("You'll find what you're looking for in the \n ocean of movies")
                .font(.body)
                .foregroundColor(.white)
               
            Spacer().frame(height: 32)
            VStack(spacing: 20) {
                StyledInputField(
                    title: "Email",
                    placeholder: "test@email.com",
                    text: $authVM.email,
                    isSecure: false,
                    showError: authVM.hasError
                ) {
                    authVM.clearError()
                }

                StyledInputField(
                    title: "Password",
                    placeholder: "123456",
                    text: $authVM.password,
                    isSecure: true,
                    showError: authVM.hasError
                ) {
                    authVM.clearError()
                }
            }
            Spacer().frame(height: 41)

            SigninButton(
                isEnabled: !authVM.email.isEmpty && !authVM.password.isEmpty
            ) {
                Task {
                    await authVM.signIn()
                }
            }
        }
    }
}


struct StyledInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    let showError: Bool
    let onEdit: () -> Void

    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible = false

    private var borderColor: Color {
        if showError {
            return .red
        } else if isFocused {
            return .yellow
        } else {
            return .clear
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
                .padding(.bottom, 2)

            ZStack(alignment: .trailing) {
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                            .focused($isFocused)
                    } else {
                        TextField(placeholder, text: $text)
                            .focused($isFocused)
                    }
                }
                .onChange(of: text) { _ in
                    onEdit()
                }
                .padding()
                .frame(width: 358, height: 44)
                .background(Color.gray.opacity(0.26))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 2)
                )
                .foregroundColor(.white)
                .accentColor(.yellow)

                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                }
            }
        }
    }
}


struct SigninButton: View {
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Sign in")
                .font(.headline)
                .foregroundColor(isEnabled ? .black : .white)
                .frame(width: 358, height: 44)
                .background(isEnabled ? Color.yellow : Color.gray)
                .cornerRadius(8)
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    SigninPage()
}
