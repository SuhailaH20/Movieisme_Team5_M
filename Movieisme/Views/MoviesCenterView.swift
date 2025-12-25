//
//  MoviesCenterView.swift
//  Movieisme
//
//  Created by Dana on 04/07/1447 AH.
//

import SwiftUI

struct MoviesCenterView: View {
    // WARNING Gemini code: State to track the active card for the dots
    @State private var activeCardIndex: Int? = 0

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                // Header, High rated, Categories
                VStack(spacing: 25) {
                    
                    // Header Section
                    VStack(alignment: .leading, spacing: 15) {
                        // title and profile icon
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
                        
                        // seach bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text("Search for Movie name, actors ...")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(12)
                        .background(Color(UIColor.gray).opacity(0.3))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    
                    // WARNING Gemini code: peak of the next movie & custom dots under the scroll view.
                    // -------------------------
                    // High rated Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("High Rated")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        // swiping gallery - currently 3
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<3) { index in
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.gray.opacity(0.3))
                                        // This creates the "Peek".
                                        // It says: "Make this card fill the width, minus 40pts of spacing".
                                        // The remaining space allows the next card to show through.
                                        .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 40)
                                        // IDs are required to track which card is active
                                        .id(index)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .contentMargins(.horizontal, 20, for: .scrollContent)
                        .scrollTargetBehavior(.viewAligned)
                        // Updates dots
                        .scrollPosition(id: $activeCardIndex)
                        .frame(height: 400)
                        
                        // Custom dots
                        HStack(spacing: 8) {
                            ForEach(0..<3) { index in
                                Circle()
                                    // Check if this dot matches the active card
                                    .fill(activeCardIndex == index ? Color.white : Color.gray)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 5)
                    }
                    // -------------------------

                    
                    // Category Section
                    MovieCategoryRow(categoryName: "Drama")
                    
                    MovieCategoryRow(categoryName: "Comedy")
                    
                    Spacer()
                }
            }
        }
    }
}

// Component to display movies for a specific category.
struct MovieCategoryRow: View {
    let categoryName: String
    
    var body: some View {
        // Titles, Scroll
        VStack(alignment: .leading, spacing: 10) {
            // titles
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
            
            // swiping gallery - currently 4.
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
