//
//  User.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-22.
//

import Foundation

class User : Codable, ObservableObject {
    
    var name : String
    var favoriteMovies : [Movie]
    
    init(name: String, favoriteMovies: [Movie]) {
        self.name = name
        self.favoriteMovies = favoriteMovies
    }
}
