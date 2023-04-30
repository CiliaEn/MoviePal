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
    @Published var popularMovies = [Movie]()
    @Published var topRatedMovies = [Movie]()
    @Published var nowPlayingMovies = [Movie]()
    @Published var searchResults = [Movie]()
    @Published var genres = [Genre]()
    
    init() {
        DispatchQueue.main.async {
            self.loadMovies(type: "popular")
            self.loadMovies(type: "top_rated")
            self.loadMovies(type: "now_playing")
            self.getGenres()
        }
    }
    
    func loadMovies(searchWord: String? = nil, type: String) {
        var apiUrl = URL(string: "")
        
        if let searchWord = searchWord {
            if let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchWord)") {
                apiUrl = url
            }
            
        } else {
            if let url = URL(string: "https://api.themoviedb.org/3/movie/\(type)?api_key=\(apiKey)") {
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
                    
                    var movies : [Movie]
                    
                    movies = result.results
                    
                    for i in 0..<movies.count {
                        let movie = movies[i]
                        group.enter()
                        
                        self.getActors(movie: movie) { actors in
                            if let actors = actors {
                                movies[i].actors = actors
                            }
                            group.leave()
                        }
                        
                        var genres: [String] = []
                        
                        group.notify(queue: .main) {
                            
                            for id in movie.genreIds {
                                if let genre = self.genres.first(where: { $0.id == id }) {
                                    genres.append(genre.name)
                                }
                            }
                            movies[i].genres = genres
                        }
                    }
                    
                    switch type {
                    case "popular":
                        self.popularMovies = movies
                    case "top_rated":
                        self.topRatedMovies = movies
                    case "now_playing":
                        self.nowPlayingMovies = movies
                    case "search":
                        self.searchResults = movies
                    default:
                        print("Error assigning movies to self")
                    }
                    
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func getGenres() {
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let genresResponse = try decoder.decode(GenresResponse.self, from: data)
                
                DispatchQueue.main.async{
                    
                    self.genres = genresResponse.genres.map { Genre(id: $0.id, name: $0.name) }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
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

func loadPoster(movie: Movie, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: "https://image.tmdb.org/t/p/w185\(movie.posterURL)") else {
        completion(nil)
        return
    }
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print("Error loading poster image: \(error.localizedDescription)")
            completion(nil)
            return
        }
        if let data = data, let image = UIImage(data: data) {
            completion(image)
        } else {
            print("Error loading poster image")
            completion(nil)
        }
    }
    task.resume()
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

struct APIResult: Codable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

struct GenresResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
