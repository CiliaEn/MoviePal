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
        
        VStack(alignment: .leading, spacing: 8) {
//            HStack{
//                VStack{
//                    MovieTrailerView(movieID: movie.id, apiManager: apiManager)
//                }
//            }
            Text(movie.title)
                .font(.title)
            Text(movie.overview)
                .font(.body)
            Text("Release Date: \(movie.releaseDate)")
                .font(.body)
            HStack {
                Text("IMDb Score:")
                    .font(.body)
                Text(String(format: "%.1f", movie.imdbScore))
                    .font(.body)
            }
            Text("Genre")
                .font(.body)
            Text("Actors: " + (showAllActors ? movie.actors.joined(separator: ", ") : movie.actors.prefix(6).joined(separator: ", ")))
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
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
}
