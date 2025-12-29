//
//  ContentView.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 03/07/1447 AH.
//

import SwiftUI

struct SigninPage: View {
    var body: some View {
      
        ZStack{
            BackgroundImage()
            InputField()
            
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
    @State private var email = ""
    @State private var password = ""

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
                    text: $email,
                    isSecure: false
                )

                StyledInputField(
                    title: "Password",
                    placeholder: "123456",
                    text: $password,
                    isSecure: true
                )
                
                
            }
            Spacer().frame(height: 41)

            SigninButton(
                isEnabled: !email.isEmpty && !password.isEmpty
            )
        }
    }
}


struct StyledInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .font(.headline)
                .padding(.bottom, 2)

            ZStack(alignment: .trailing) {
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.26))
                .frame(width: 358, height: 44)
                .cornerRadius(8)
                .foregroundColor(.white)
                .accentColor(.yellow)

                if isSecure {
                    Image(systemName: "eye.slash")
                        .foregroundColor(.gray)
                        .padding(.trailing, 12)
                }
            }
        }
    }
}


struct SigninButton: View {
    let isEnabled: Bool

    var body: some View {
        Button(action: {
            print("Signed in")
        }) {
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
