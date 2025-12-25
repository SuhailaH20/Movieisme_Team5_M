//
//  EditProfileView.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 07/07/1447 AH.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var user: ProfileUser

    @State private var firstName: String = ""
    @State private var lastName: String = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {

                Divider()
                    .background(Color.black.opacity(0.15))

                VStack(spacing: 18) {

                    ZStack {
                        Image(user.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 88, height: 88)
                            .clipShape(Circle())
                            .opacity(0.9)

                        Circle()
                            .fill(Color.black.opacity(0.35))
                            .frame(width: 88, height: 88)

                        Image(systemName: "camera.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.yellow)
                            .padding(10)
                            .background(Circle().fill(Color.black.opacity(0.35)))
                    }
                    .padding(.top, 18)

                    VStack(spacing: 0) {
                        ProfileTextFieldRow(title: "First name", text: $firstName)
                        Divider().background(Color.white.opacity(0.08))
                        ProfileTextFieldRow(title: "Last name", text: $lastName)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal, 18)

                    Spacer()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            firstName = user.firstName
            lastName = user.lastName
        }
        .toolbar {

            ToolbarItem(placement: .principal) {
                Text("Edit profile")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    user.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                    user.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                    dismiss()
                } label: {
                    Text("Save")
                        .foregroundStyle(.yellow)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }
}

private struct ProfileTextFieldRow: View {
    let title: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white.opacity(0.75))
                .font(.system(size: 15, weight: .regular))

            Spacer()

            TextField("", text: $text)
                .multilineTextAlignment(.trailing)
                .foregroundStyle(.white)
                .font(.system(size: 15, weight: .semibold))
                .textInputAutocapitalization(.words)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

