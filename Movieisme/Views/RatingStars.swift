//
//  RatingStars.swift
//  Movieisme
//
//  Created by شهد عبدالله القحطاني on 14/07/1447 AH.
//
//
//
//import SwiftUI
//
//struct RatingStars: View {
//    @Binding var rating: Int
//    
//    var body: some View {
//        HStack(spacing: 8) {
//            ForEach(1...5, id: \.self) { index in
//                Button(action: {
//                    rating = index
//                }) {
//                    Image(systemName: index <= rating ? "star.fill" : "star")
//                        .font(.title2)
//                        .foregroundColor(index <= rating ? .yellow : .gray)
//                }
//            }
//        }
//    }
//}
