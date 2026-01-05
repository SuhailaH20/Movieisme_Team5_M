

import SwiftUI

struct MoviesCenterView: View {
    @StateObject private var viewModel = MoviesCenterViewModel()
    @State private var searchText = ""
    @State private var showErrorAlert = false
    
    @State private var showProfile = false
    
    var highRatedMovies: [MovieRecord] {
        viewModel.movies
            .filter { $0.fields.IMDb_rating >= 4.5 }
            .sorted { $0.fields.IMDb_rating > $1.fields.IMDb_rating }
    }
    
    func moviesForCategory(_ genre: String) -> [MovieRecord] {
        viewModel.movies.filter { $0.fields.genre.contains(genre) }
    }
    
    var searchResults: [MovieRecord] {
        if searchText.isEmpty { return [] }
        return viewModel.movies.filter { movie in
            movie.fields.name.localizedCaseInsensitiveContains(searchText) ||
            (movie.fields.genre.first?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    HeaderView(searchText: $searchText, onProfileTap: {
                        showProfile = true
                    })
                    
                    if viewModel.isLoading {
                        ProgressView().tint(.white).frame(height: 200)
                    } else if viewModel.movies.isEmpty {
                        VStack(spacing: 20) {
                             Image(systemName: "film")
                                 .font(.system(size: 50))
                                 .foregroundColor(.gray)
                             Text("No movies available").foregroundColor(.gray)
                             
                             Button(action: { Task { await viewModel.loadMovies() } }) {
                                 Text("Refresh")
                                     .fontWeight(.semibold)
                                     .foregroundColor(.black)
                                     .padding(.horizontal, 25)
                                     .padding(.vertical, 12)
                                     .background(Color.yellow)
                                     .cornerRadius(8)
                             }
                         }.frame(height: 400)
                    } else {
                        if searchText.isEmpty {
                            HighRatedView(movies: highRatedMovies)
                            
                            MovieCategoryRow(categoryName: "Drama", movies: moviesForCategory("Drama"))
                            MovieCategoryRow(categoryName: "Comedy", movies: moviesForCategory("Comedy"))
                            MovieCategoryRow(categoryName: "Action", movies: moviesForCategory("Action"))
                            
                        } else {
                            if searchResults.isEmpty {
                                Text("No movies found")
                                    .foregroundColor(.gray)
                                    .padding(.top, 50)
                            } else {
                                LazyVGrid(columns: columns, spacing: 15) {
                                    ForEach(searchResults) { movie in
                                        
                                        NavigationLink(destination: MovieDetails(movieID: movie.id)) {
                                            
                                            GeometryReader { geo in
                                                AsyncImage(url: URL(string: movie.fields.poster)) { phase in
                                                    switch phase {
                                                    case .success(let image):
                                                        image.resizable().scaledToFill()
                                                    case .empty:
                                                        Color.gray.opacity(0.3)
                                                    case .failure:
                                                        ZStack {
                                                            Color.gray.opacity(0.3)
                                                            Image(systemName: "photo.badge.exclamationmark")
                                                                .foregroundColor(.white.opacity(0.5))
                                                        }
                                                    @unknown default:
                                                        Color.gray.opacity(0.3)
                                                    }
                                                }
                                                .frame(width: geo.size.width, height: 160)
                                                .clipped()
                                            }
                                            .frame(height: 160)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 30)
            }
        }
        .task { await viewModel.loadMovies() }
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showProfile) {
            ProfileView()
        }
        .alert("Connection Issue", isPresented: $showErrorAlert) {
            Button("Retry") { Task { await viewModel.loadMovies() } }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "Unable to load data.")
        }
        .onChange(of: viewModel.errorMessage) { newValue in
            if newValue != nil { showErrorAlert = true }
        }
    }
}
