//
//  userInfoCard.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 04/07/1447 AH.
//

import SwiftUI

struct UserInfoCardView: View {
    let fullName: String
    let email: String
    let imageName: String

    var body: some View {
        HStack(spacing: 16) {

            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text(fullName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)

                Text(email)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.white.opacity(0.85))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}

