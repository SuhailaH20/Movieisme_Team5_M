//
//  ProfileView.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 04/07/1447 AH.
//

import SwiftUI

struct ProfileView: View {
    private let columns = [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)]

    @State private var user = ProfileUser(
        firstName: "Sarah", lastName: "Abdullah", email: "xxxx234@gmail.com", imageName: "ProfileImg"
    )

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Profile").font(.system(size: 37, weight: .bold)).foregroundStyle(.white)

                        NavigationLink {
                            ProfileInfoView(user: $user)
                        } label: {
                            UserInfoCardView(fullName: user.fullName, email: user.email, imageName: user.imageName)
                        }
                        .buttonStyle(.plain)

                        Text("Saved movies").font(.system(size: 27, weight: .semibold)).foregroundStyle(.white)

                        LazyVGrid(columns: columns, spacing: 14) {
                            MoviePosterCard(imageName: "SavedMoviPoster1")
                            MoviePosterCard(imageName: "SavedMoviPoster2")
                            MoviePosterCard(imageName: "SavedMoviPoster3")
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {} label: {
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
