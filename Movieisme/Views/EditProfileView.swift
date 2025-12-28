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
        ProfileScreen(title: "Edit profile", trailing: {
            Button {
                user.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                user.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                dismiss()
            } label: {
                Text("Save")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 16, weight: .semibold))
            }
        }) {
            ProfileAvatarView(imageName: user.imageName, size: 88, showCameraOverlay: true)

            ProfileInfoCard {
                ProfileTextFieldRow(title: "First name", text: $firstName)
                Divider().background(Color.white.opacity(0.08))
                ProfileTextFieldRow(title: "Last name", text: $lastName)
            }

            Spacer()
        }
        .onAppear {
            firstName = user.firstName
            lastName = user.lastName
        }
    }
}
