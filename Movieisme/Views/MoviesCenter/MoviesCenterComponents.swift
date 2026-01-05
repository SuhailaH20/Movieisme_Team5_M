

import SwiftUI

// Header
struct HeaderView: View {
    @Binding var searchText: String
    
    var onProfileTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Movies Center")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    onProfileTap()
                }) {
                    Circle()
                        .fill(Color(UIColor.gray).opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(Text("👩🏻"))
                }
            }
            
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("", text: $searchText, prompt: Text("Search for Movie name, actors ...")
                    .foregroundColor(.white.opacity(0.5)))
                .foregroundColor(.white)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .padding(12)
            .background(Color(UIColor.gray).opacity(0.3))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

// High Rated
struct HighRatedView: View {
    let movies: [MovieRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("High Rated")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            if movies.isEmpty {
                Text("No high rated movies found")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .frame(height: 400)
            } else {
                TabView {
                    ForEach(movies) { movie in
                        HighRatedCard(movie: movie)
                    }
                }
                .frame(height: 400)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
        }
    }
}

struct HighRatedCard: View {
    let movie: MovieRecord
    
    var body: some View {
        NavigationLink(destination: MovieDetails(movieID: movie.id)) {
            
            let ratingOutOf5 = movie.fields.IMDb_rating / 2
            let starCount = Int(ratingOutOf5)
            let genreName = movie.fields.genre.first ?? "Unknown"
            let runtime = movie.fields.runtime
            
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                    
                    if let url = URL(string: movie.fields.poster), !movie.fields.poster.isEmpty {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().scaledToFill()
                            case .empty:
                                Color.gray.opacity(0.3)
                            case .failure:
                                ZStack {
                                    Color.gray.opacity(0.3)
                                    Image(systemName: "photo.badge.exclamationmark")
                                        .font(.largeTitle)
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            @unknown default:
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: geometry.size.width, height: 400)
                        .clipped()
                    } else {
                        ZStack {
                            Color.gray.opacity(0.3)
                            Image(systemName: "photo.badge.exclamationmark")
                                .font(.largeTitle)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(width: geometry.size.width, height: 400)
                    }
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.9), Color.black.opacity(0.0)]),
                        startPoint: .bottom, endPoint: .center
                    )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(movie.fields.name)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        VStack(spacing: 4) {
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < starCount ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                            }
                            HStack(spacing: 4) {
                                Text(String(format: "%.1f", ratingOutOf5)).fontWeight(.bold)
                                Text("out of 5").font(.caption)
                            }
                            .foregroundColor(.white)
                        }
                        Text("\(genreName) . \(runtime)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(20)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .cornerRadius(20)
            }
            .padding(.horizontal, 20)
            .tag(movie.id)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MovieCategoryRow: View {
    let categoryName: String
    let movies: [MovieRecord]
    
    var body: some View {
        if !movies.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(categoryName).font(.headline).foregroundColor(.white)
                    Spacer()
                    Text("Show more").font(.caption).foregroundColor(.yellow)
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(movies) { movie in
                            
                            NavigationLink(destination: MovieDetails(movieID: movie.id)) {
                                
                                if let url = URL(string: movie.fields.poster), !movie.fields.poster.isEmpty {
                                    AsyncImage(url: url) { phase in
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
                                    .frame(width: 140, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                } else {
                                    ZStack {
                                        Color.gray.opacity(0.3)
                                        Image(systemName: "photo.badge.exclamationmark")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .frame(width: 140, height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
