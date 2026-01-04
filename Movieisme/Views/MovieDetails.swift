//
//  MovieDetails.swift
//  Movieisme
//

import SwiftUI

struct MovieDetails: View {
    @StateObject var viewModel = MovieDetailsViewModel()
    let movieID: String
    
    // ضع الـ userID الخاص بالمستخدم الحالي - يمكن تمريره من الـ Authentication
    let currentUserID: String = "rec9fbIQzzfNumaav" // غيّر هذا حسب نظام الـ Authentication عندك
    
    @State private var showTitle = false
    @State private var showAddReview = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let movie = viewModel.movie {
                    ScrollView {
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .global).minY) { value in
                                    showTitle = value < -80
                                }
                        }
                        .frame(height: 0)

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
                            
                            if let director = viewModel.director {
                                DirectorSection(director: director)
                            }

                            Spacer().frame(height: 16)
                            
                            if !viewModel.actors.isEmpty {
                                StarSection(actors: viewModel.actors)
                            }
                            
                            Divider()
                                .background(Color.gray)
                                .padding(.vertical, 8)
                            
                            RatingandReview(
                                viewModel: viewModel,
                                onWriteReview: {
                                    showAddReview = true
                                }
                            )
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
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(.yellow))
                }

                ToolbarItem(placement: .principal) {
                    if showTitle, let movie = viewModel.movie {
                        Text(movie.name)
                            .font(.headline)
                            .lineLimit(1)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if let movie = viewModel.movie {
                        ShareLink(item: "Watch with me \(movie.name)!🍿") {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(.yellow)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "bookmark")
                        .foregroundStyle(Color(.yellow))
                }
            }
            .task {
                await viewModel.loadMovie(id: movieID)
            }
            .sheet(isPresented: $showAddReview) {
                let currentMovieID = movieID
                AddReviewView(
                    movieID: currentMovieID,
                    userID: currentUserID,
                    onAdded: {
                        Task {
                            await viewModel.loadReviews(movieID: movieID)
                        }
                    }
                )
            }
        }
    }
}

struct CoverImage: View {
    let urlString: String

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            if let image = phase.image {
                ZStack {
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
                }
                .frame(maxHeight: 300)
            }
        }
    }
}

struct MovieOverview: View {
    let movie: Movie
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.fixed(119), spacing: 70),
            GridItem(.fixed(119), spacing: 70)
        ], alignment: .leading, spacing: 32) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Duration")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("\(movie.runtime)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Language")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("\(movie.language.joined(separator: ", "))")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
            }
            
            VStack(alignment: .leading, spacing: 8) {
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
        VStack(alignment: .leading, spacing: 8) {
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
        VStack(alignment: .leading, spacing: 8) {
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
        VStack(alignment: .leading, spacing: 8) {
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
    let onWriteReview: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating & Reviews")
                .font(.system(size: 18, weight: .semibold))
            
            Text(String(format: "%.1f", viewModel.averageRating))
                .font(.system(size: 39, weight: .medium))
                .foregroundColor(Color("greyish"))
            
            Text("out of 5")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("greyish"))
            
            Spacer().frame(height: 20)
            
            if viewModel.reviews.isEmpty {
                VStack(spacing: 16) {
                    Text("No reviews yet")
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    Button(action: onWriteReview) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                            Text("Write a review")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                    }
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(viewModel.reviews) { review in
                            ReviewCard(review: review)
                        }
                    }
                }
                
                Spacer().frame(height: 16)
                
                Button(action: onWriteReview) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                        Text("Write a review")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .foregroundColor(.yellow)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.yellow, lineWidth: 1)
                    )
                }
            }
        }
    }
}

struct ReviewCard: View {
    let review: MovieReview

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
        }
        .frame(width: 350, height: 160)
        .padding()
        .background(Color.white.opacity(0.09))
        .cornerRadius(8)
    }
}

#Preview {
    MovieDetails(movieID: "reckJmZ458CZcLlUd")
}

