//
//  MoviesCenterView.swift
//  Movieisme
//
//  Created by Dana on 04/07/1447 AH.
//

import SwiftUI

struct MoviesCenterView: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 25) {
                    
                    // Header Component
                    HeaderView()
                    
                    // High Rated Component
                    HighRatedView()
                    
                    // Category Components
                    MovieCategoryRow(categoryName: "Drama")
                    MovieCategoryRow(categoryName: "Comedy")
                    
                    Spacer()
                }
                .padding(.top, 30)
            }
        }
    }
}

// Header Component
struct HeaderView: View {
    @State private var searchText = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Title and profile icon
            HStack {
                Text("Movies Center")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Circle()
                    .fill(Color(UIColor.gray).opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(Text("👩🏻"))
            }
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("", text: $searchText, prompt: Text("Search for Movie name, actors ...")
                    .foregroundColor(.white.opacity(0.5))
                )
                .foregroundColor(.white)
                
                Spacer()
            }
            .padding(12)
            .background(Color(UIColor.gray).opacity(0.3))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

// High Rated Component
struct HighRatedView: View {
    @State private var activeCardIndex: Int? = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("High Rated")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // Swiping gallery
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<3) { index in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.3))
                            .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 40)
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 20, for: .scrollContent)
//            .scrollTargetBehavior(.viewAligned) // removed for free scrolling effect
            .scrollPosition(id: $activeCardIndex)
            .frame(height: 400)
            
            // Custom dots
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(activeCardIndex == index ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 5)
        }
    }
}

// Category Row Component
struct MovieCategoryRow: View {
    let categoryName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Titles
            HStack {
                Text(categoryName)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("Show more")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal)
            
            // Swiping gallery
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(0..<4) { _ in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 140, height: 200)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    MoviesCenterView()
}
