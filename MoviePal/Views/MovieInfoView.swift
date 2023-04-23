//
//  MovieInfoView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-04-18.
//

import SwiftUI

struct MovieInfoView: View {
    
    @State var movie: Movie
    let userManager: UserManager
    let apiManager: APIManager
    
    @State private var showAllActors = false
    
    var body: some View {
        
        ZStack{
            Color(red: 20/255, green: 20/255, blue: 20/255)
                .ignoresSafeArea()
            
            
            VStack (alignment: .leading, spacing: 8){
                MovieTrailerView(movieID: movie.id, apiManager: apiManager)
                
                Text(movie.title)
                    .font(.title)
                    .foregroundColor(.white)
                Text(movie.overview)
                    .font(.body)
                    .foregroundColor(.white)
                Text("Release Date: \(movie.releaseDate)")
                    .font(.body)
                    .foregroundColor(.white)
                HStack {
                    Text("IMDb Score:")
                        .font(.body)
                        .foregroundColor(.white)
                    Text(String(format: "%.1f", movie.imdbScore))
                        .font(.body)
                        .foregroundColor(.white)
                }
                Text("Genre: " + movie.genres.joined(separator: ", "))
                    .font(.body)
                    .foregroundColor(.white)
                Text("Actors: " + (showAllActors ? movie.actors.joined(separator: ", ") : movie.actors.prefix(6).joined(separator: ", ")) + "...")
                    .font(.body)
                    .lineLimit(nil)
                    .onTapGesture {
                        self.showAllActors.toggle()
                    }
                
                Button(action: {
                    if let user = userManager.user {
                        if (user.checkForFavorite(movie: movie)) {
                            print("removeMovie")
                            user.removeMovie(movie: movie)
                        } else {
                            print("addMovie")
                            user.addMovie(movie: movie)
                        }
                        userManager.saveUserToFirestore()
                    } else {
                        print("You have to log in to favorite movies")
                    }
                }) {
                    if let user = userManager.user {
                        if user.checkForFavorite(movie: movie) {
                            Image(systemName: "heart.fill")
                        } else if user.checkForFavorite(movie: movie) == false {
                            Image(systemName: "heart")
                        }
                    } else {
                        Image(systemName: "heart")
                    }
                }
            }
            .padding()
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
    
}


