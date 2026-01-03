//
//  MovieDetailsComponents.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 04/07/1447 AH.
//

import SwiftUI

struct CoverImage: View {
    let urlString: String

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                ZStack{
                    image
                        .resizable()
                        .scaledToFill()
                        .padding(.top, -100)
                
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.999),
                            Color.black.opacity(0)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                } .frame(maxHeight: 300)
            }
        }
    }
}

struct MovieOverview: View {
    let movie: Movie
    
    var body: some View {
        
        LazyVGrid(columns: [
            GridItem(.fixed(119),spacing: 70),
            GridItem(.fixed(119),spacing: 70)
        ],alignment: .leading,  spacing: 32){
            
            VStack(alignment: .leading, spacing: 8){
                Text("Duration")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("\(movie.runtime)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text("Language")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("\(movie.language.joined(separator: ", "))")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
                
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text("Genre")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("\(movie.genre.joined(separator: ", "))")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
                
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Age")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("\(movie.rating)")
                    .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("greyish"))
            }
        }
    }
}

struct StorySection: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Story")
                .font(.system(size: 18, weight: .semibold))
            Text(movie.story)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("greyish"))
   
        }
    }
}

struct RatingSection: View {
    let rating: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("IMDb Rating")
                .font(.system(size: 18, weight: .semibold))
            
            Text(String(format: "%.1f / 10", rating))
                .font(.system(size: 15))
                .foregroundColor(Color("greyish"))
    
        }
    }
}

struct DirectorSection: View {
    let director: Director

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Director")
                .font(.system(size: 18, weight: .semibold))

            AsyncImage(url: URL(string: director.image)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 76, height: 76)
            .clipShape(Circle())

            Text(director.name)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("greyish"))
        }
    }
}

struct StarSection: View {
    let actors: [Actor]

    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Stars")
                .font(.system(size: 18, weight: .semibold))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(actors) { actor in
                        VStack {
                            AsyncImage(url: URL(string: actor.image)) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 76, height: 76)
                            .clipShape(Circle())

                            Text(actor.name)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color("greyish"))
                        }
                    }
                }

            }
        }
    }
}

struct RatingandReview: View {
    @ObservedObject var viewModel: MovieDetailsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating & Reviews")
                .font(.system(size: 18, weight: .semibold))
            
            //how can i make this dynamic????
            Text("4.8")
                .font(.system(size: 39, weight: .medium))
                .foregroundColor(Color("greyish"))
            
            Text("out of 5")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("greyish"))
            
            Spacer().frame(height: 20)
            
            if viewModel.reviews.isEmpty {
                Text("No reviews yet")
                    .foregroundColor(.gray)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20){
                        ForEach(viewModel.reviews) { review in
                            ReviewCard(review: review)
                        }
                    }
                }
            }
        }
    }
}


struct ReviewCard: View {
    let review: MovieReview
    //not dynamic yet i need to build a func to map or translate the data into something similr to this format
    let date: String = "2 days ago"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: URL(string: review.authorImage)) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 36, height: 36)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(review.author)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < review.rating ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                }

                Spacer()
            }

            Text(review.text)
                .font(.footnote)
                .foregroundColor(.white)
                .lineLimit(4)

            Spacer()

            HStack {
                Spacer()
                
                
                Text(date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 350, height: 180)
        .padding()
        .background(Color.white.opacity(0.09))
        .cornerRadius(8)
    }
}
