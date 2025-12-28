//
//  ProfileInfoView.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 07/07/1447 AH.
//
import SwiftUI

struct ProfileInfoView: View {
    @Binding var user: ProfileUser

    var body: some View {
        ProfileScreen(title: "Profile info", trailing: {
            NavigationLink {
                EditProfileView(user: $user)
            } label: {
                Text("Edit")
                    .foregroundStyle(.yellow)
                    .font(.system(size: 16, weight: .semibold))
            }
        }) {
            ProfileAvatarView(imageName: user.imageName, size: 80)

            ProfileInfoCard {
                ProfileInfoRow(title: "First name", value: user.firstName)
                Divider().background(Color.white.opacity(0.08))
                ProfileInfoRow(title: "Last name", value: user.lastName)
            }

            Spacer()

            ProfileDangerButton(title: "Sign Out") {
                
            }
        }
    }
}
