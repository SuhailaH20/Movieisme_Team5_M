//
//  MovieDetails.swift
//  Movieisme
//
//  Created by Suhaylah hawsawi on 04/07/1447 AH.
//

import SwiftUI

struct MovieDetails: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    CoverImage()
                    
                    Text("Shawshank")
                      .font(.system(size: 28, weight: .bold))
       
                    Spacer().frame(height: 40)
                    
                    MoivesOverview()
             
                    Spacer().frame(height: 32)
                    
                    StorySection()
                    
                    Spacer().frame(height: 32)
                }
            }
        }
    }
    
}


struct CoverImage: View {
    var body: some View {
        ZStack {
            Image("Shawshankscoverimage")
                .resizable()
                .scaledToFill()
                .padding(.top, -80)
            
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.9),
                    Color.black.opacity(0)
                ]),
                startPoint: .bottom,
                endPoint: .top
            )
        }
    }
}


struct MoivesOverview: View {
    var body: some View {
        
        LazyVGrid(columns: [
            GridItem(.fixed(119),spacing: 70),
            GridItem(.fixed(119),spacing: 70)
        ],alignment: .leading,  spacing: 32){
            
            VStack(alignment: .leading, spacing: 8){
                Text("Duration")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("2 hours 22 mins")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
            }
            
            
            VStack(alignment: .leading, spacing: 8){
                Text("Language")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("English")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
                
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text("Genre")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Drama")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
                
            }
            
            VStack(alignment: .leading, spacing: 8){
                Text("Age")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("+15")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(Color("greyish"))
                
            }
        }
    }
}

struct StorySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("Story")
                .font(.system(size: 18, weight: .semibold))
            
            Text("Synopsis. In 1947, Andy Dufresne (Tim Robbins), a banker in Maine, is convicted of murdering his wife and her lover, a golf pro. Since the state of Maine has no death penalty, he is given two consecutive life sentences and sent to the notoriously harsh Shawshank Prison.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("greyish"))
   
        }
    }
}

#Preview {
    MovieDetails()
}
