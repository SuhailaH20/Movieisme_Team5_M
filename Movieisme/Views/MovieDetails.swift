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
                
                CoverImage()
                VStack(alignment: .leading) {
                    
                    Text("Shawshank")
                      .font(.system(size: 28, weight: .bold))
       
                    Spacer().frame(height: 40)
                    
                    MoivesOverview()
             
                    Spacer().frame(height: 32)
                    
                    StorySection()
                    
                    Spacer().frame(height: 32)
                    
                    RatingSection()
                    
                    Divider()
                        .background(Color.gray)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                    
                    DirectorSection()
                }.padding(.horizontal)
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
                    Color.black.opacity(0.999),
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

struct RatingSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8){
            Text("IMDb Rating")
                .font(.system(size: 18, weight: .semibold))
    
            Text("9.3 / 10")
                .font(.system(size: 15, weight: .medium))
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

#Preview {
    MovieDetails()
}
