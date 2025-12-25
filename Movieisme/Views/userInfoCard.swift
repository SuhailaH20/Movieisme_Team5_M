//
//  userInfoCard.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 04/07/1447 AH.
//

import SwiftUI

var userInfoCard: some View {
    HStack(spacing: 16) {
        
        
        Image("ProfileImg")
            .resizable()
            .scaledToFill()
            .frame(width: 70, height: 70)
            .clipShape(Circle())

        VStack(alignment: .leading, spacing: 6) {

            
            Text("Sarah Abdullah")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)


            Text("xxxx234@gmail.com")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white)
        }

        Spacer()

        Image(systemName: "chevron.right")
            .foregroundStyle(.white.opacity(0.6))
    }
    .padding(16)
    .background(
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(.secondarySystemBackground)))
}


#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}

