//
//  User.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-22.
//

import Foundation

class User : Codable, ObservableObject {
    
    var email : String
    var favoriteMovies = [Movie]()
    
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
        
        if let index = favoriteMovies.firstIndex(of: movie) {
            favoriteMovies.remove(at: index)
            print("movie removed from favorites")
        }
    }
    func checkForFavorite(movie: Movie) -> Bool {
        
        if (favoriteMovies.contains(movie)) {
            return true
        } else {
            return false
        }
    }
}
