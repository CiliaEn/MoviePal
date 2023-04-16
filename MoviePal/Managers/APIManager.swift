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
    @Published var movies = [Movie]()
    
    init() {
            DispatchQueue.main.async {
                self.loadMovies()
            }
        }
    
    func loadMovies(searchWord: String? = nil) {
        var apiUrl = URL(string: "")
        
        if let searchWord = searchWord {
            if let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchWord)") {
                apiUrl = url
            }
             
        } else {
            if let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)") {
                apiUrl = url
            }
        }
        
        guard let url = apiUrl else {
            print("Error: Invalid URL")
            return
        }
        
        let group = DispatchGroup()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("Error: No data returned from API.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(APIResult.self, from: data)
                
                DispatchQueue.main.async {
                    self.movies = result.results
                    
                    for i in 0..<self.movies.count {
                        let movie = self.movies[i]
                        group.enter()
                        
                        self.getActors(movie: movie) { actors in
                            if let actors = actors {
                                self.movies[i].actors = actors
                            }
                            group.leave()
                        }
                    }
                    
                    group.notify(queue: DispatchQueue.main) {
                        print("Finished loading movies with actors.")
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    struct APIResult: Codable {
        let page: Int
        let results: [Movie]
        let total_pages: Int
        let total_results: Int
    }
    
    func getActors(movie: Movie, completion: @escaping ([String]?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movie.id)/credits?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let credits = try decoder.decode(CreditsResponse.self, from: data)
                
                let actors = credits.cast.map { $0.name }
                DispatchQueue.main.async {
                    completion(actors)
                }
                
            } catch let error {
                print(error.localizedDescription)
                completion(nil)
            }
        }
        
        task.resume()
    }
}



struct CreditsResponse: Codable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Codable {
    let id: Int
    let name: String
    let character: String
}
