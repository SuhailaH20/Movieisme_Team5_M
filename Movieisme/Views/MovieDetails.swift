//
//  MovieDetails.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 04/07/1447 AH.
//

import SwiftUI

struct MovieDetails: View {
    @StateObject var viewModel = MovieDetailsViewModel()
    let movieID: String

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let movie = viewModel.movie {
                    ScrollView {
                        CoverImage(urlString: movie.poster)

                        VStack(alignment: .leading) {
                            Text(movie.name)
                                .font(.system(size: 28, weight: .bold))
                            Spacer().frame(height: 20)

                            MovieOverview(movie: movie)
                            Spacer().frame(height: 32)

                            StorySection(movie: movie)
                            Spacer().frame(height: 32)

                            RatingSection(rating: movie.IMDb_rating)
                            
                            Divider()
                                .background(Color.gray)
                                .padding(.vertical, 8)
                            
                            DirectorSection()
                            Spacer().frame(height: 16)
                            
                            StarSection()
                            
                            Divider()
                                .background(Color.gray)
                                .padding(.vertical, 8)
                            
                            RatingandReview()
                        }
                        .padding(.horizontal)
                    }
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    Text("No data")
                        .foregroundColor(.gray)
                }
            }
            .task {
                await viewModel.loadMovie(id: movieID)
            }
        }
    }
}



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
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Director")
                .font(.system(size: 18, weight: .semibold))
            
            Image("FrankDarabont")
                .resizable()
                .scaledToFill()
                .frame(width: 76, height: 76)
                .clipShape(Circle())
            
            Text("Frank Darabont")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("greyish"))
        }
    }
}

struct StarSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Stars")
                .font(.system(size: 18, weight: .semibold))
            
            HStack(spacing: 24){
                VStack{
                    Image("TimRobbins")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 76, height: 76)
                        .clipShape(Circle())
                    
                    Text("Tim Robbins")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("greyish"))
                }
                
                VStack{
                    Image("BobGunton")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 76, height: 76)
                        .clipShape(Circle())
                    
                    Text("Bob Gunton")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("greyish"))
                }
                
                VStack{
                    Image("MorganFreeman")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 76, height: 76)
                        .clipShape(Circle())
                    
                    Text("Morgan Freeman")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color("greyish"))
                }

            }
        }
    }
}

struct RatingandReview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Rating  & Reviews ")
                .font(.system(size: 18, weight: .semibold))
            
            Text("4.8")
                .font(.system(size: 39, weight: .medium))
                .foregroundColor(Color("greyish"))
            
            Text("out of 5")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("greyish"))
            
            Spacer().frame(height: 32)
            
            ReviewCard(
                author: "Afnan Abdullah",
                review: "This is an engagingly simple, good-hearted film, with just enough darkness around the edges to give contrast and relief to its glowingly benign view of human nature.",
                rating: 4,
                date: "2 days ago"
            )
            
        }
    }
}

struct ReviewCard: View {
    let author: String
    let review: String
    let rating: Int
    let date: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            
            HStack(alignment: .top) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 36, height: 36)

                VStack(alignment: .leading, spacing: 4) {
                    Text(author)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                   
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < rating ? "star.fill" : "star")
                                .font(.caption)
                                .foregroundColor(.yellow)
                        }
                    }
                }

            }

           
            Text(review)
                .font(.footnote)
                .foregroundColor(Color.white)
            
            HStack{
                Spacer()
                
                
                Text(date)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white.opacity(0.09))
        .cornerRadius(8)
    }
}


#Preview {
    MovieDetails(movieID: "reckJmZ458CZcLlUd")
}
