//
//  Movie.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-20.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterURL: String?
    let releaseDate: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterURL = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
