
import SwiftUI

struct MovieDetails: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = MovieDetailsViewModel()
    let movieID: String

    var currentUserID: String {
        return UserSession.currentUserID
    }
    
    @State private var showTitle = false
    @State private var isSaved = false
    
    @State private var showAddReview = false

    var body: some View {
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
                        
                        Divider().background(Color.gray).padding(.vertical, 8)
                        
                        if let director = viewModel.director {
                            DirectorSection(director: director)
                        }

                        Spacer().frame(height: 16)
                        
                        if !viewModel.actors.isEmpty {
                            StarSection(actors: viewModel.actors)
                        }
                        
                        Divider().background(Color.gray).padding(.vertical, 8)
                        
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
                Text(error).foregroundColor(.red).padding()
            } else {
                Text("No data").foregroundColor(.gray)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.yellow)
                        .imageScale(.large)
                        .fontWeight(.bold)
                }
            }
            
            ToolbarItem(placement: .principal) {
                if showTitle, let movie = viewModel.movie {
                    Text(movie.name).font(.headline).lineLimit(1)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if let movie = viewModel.movie {
                    ShareLink(item: "Watch with me \(movie.name)!🍿") {
                        Image(systemName: "square.and.arrow.up").foregroundStyle(.yellow)
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isSaved.toggle()
                    Task {
                        if isSaved { await viewModel.saveMovie(movieID: movieID) }
                    }
                }) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(Color.yellow)
                }
            }
        }
        .task {
            await viewModel.loadMovie(id: movieID)
        }
        .sheet(isPresented: $showAddReview) {
            AddReviewView(
                movieID: movieID,
                userID: currentUserID,
                onAdded: {
                    // Reload reviews after adding one
                    Task {
                        await viewModel.loadReviews(movieID: movieID)
                    }
                }
            )
        }
    }
}
