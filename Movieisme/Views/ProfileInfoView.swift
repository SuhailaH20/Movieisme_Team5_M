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
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {

                Divider()
                    .background(Color.black.opacity(0.15))

                VStack(spacing: 18) {

                    // Avatar
                    Image(user.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.top, 18)

                    // Info Card
                    VStack(spacing: 0) {
                        ProfileInfoRow(title: "First name", value: user.firstName)
                        Divider().background(Color.white.opacity(0.08))
                        ProfileInfoRow(title: "Last name", value: user.lastName)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal, 18)

                    Spacer()

                    Button {
                        // sign out action
                    } label: {
                        Text("Sign Out")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.secondarySystemBackground))
                            )
                            .padding(.horizontal, 18)
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Profile info")
                    .foregroundStyle(.white)
                    .font(.system(size: 16, weight: .semibold))
            }

            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    EditProfileView(user: $user)
                } label: {
                    Text("Edit")
                        .foregroundStyle(.yellow)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }
}

private struct ProfileInfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.white.opacity(0.75))
                .font(.system(size: 15, weight: .regular))
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .font(.system(size: 15, weight: .semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
