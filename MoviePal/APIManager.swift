//
//  APIManager.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-20.
//

import Foundation
import SwiftUI

class APIManager: ObservableObject {
    
    let apiKey = "1ab1f7c880d64fe323e8e76edec25435"
    @Published var movies: [Movie] = []
    
    func loadData() {
        //popular movies, change this later to take in a parameter
        let apiUrl = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)")!

        let task = URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            guard let data = data else {
                print("Error: No data returned from API.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(APIResult.self, from: data)
                self.movies = result.results
                
                print("Success decoding movies")
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

struct APIResult: Codable {
    let page: Int
    let results: [Movie]
}
