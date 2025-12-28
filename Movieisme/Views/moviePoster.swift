//
//  moviePoster.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 04/07/1447 AH.
//

import SwiftUI

extension ProfileView {

    func moviePoster(_ imageName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.white.opacity(0.08))

            Image(imageName) 
                .resizable()
                .scaledToFill()
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.white.opacity(0.1))
        )
    }
}

#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}

