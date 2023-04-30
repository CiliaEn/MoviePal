//
//  User.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-22.
//

import Foundation
import Combine

class User: ObservableObject, Codable {
    
    var email: String
    var favoriteMovies: [Movie]
    
    init(email: String, favoriteMovies: [Movie] = []) {
        self.email = email
        self.favoriteMovies = favoriteMovies
    }
    
    func addMovie(movie: Movie) {
        if (!favoriteMovies.contains(movie)) {
            self.favoriteMovies.append(movie)
            print("movie added to favorites")
        }
    }
    
    func removeMovie(movie: Movie) {
        favoriteMovies = favoriteMovies.filter { $0.id != movie.id }
        print("movie removed from favorites")
    }
    
    func checkForFavorite(movie: Movie) -> Bool {
        for favoriteMovie in favoriteMovies {
            if favoriteMovie.id == movie.id {
                return true
            }
        }
        return false
    }
}
