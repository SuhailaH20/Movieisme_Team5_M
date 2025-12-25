//
//  ProfileView.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 04/07/1447 AH.
//

import SwiftUI

struct ProfileView: View {

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {

                        // Title
                        Text("Profile")
                            .font(.system(size: 37, weight: .bold))
                            .foregroundStyle(.white)

                        // User Card
                        userInfoCard

                        // Saved Movies
                        Text("Saved movies")
                            .font(.system(size: 27, weight: .semibold))
                            .foregroundStyle(.white)

                        LazyVGrid(columns: columns, spacing: 14) {
                            moviePoster("SavedMoviPoster1")
                            moviePoster("SavedMoviPoster2")
                            moviePoster("SavedMoviPoster3")
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // dismiss()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundStyle(.yellow)
                        .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
        }
    }
}
#Preview {
    ProfileView()
        .preferredColorScheme(.dark)
}
