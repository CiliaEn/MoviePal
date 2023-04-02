//
//  MovieTrailerView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-04-02.
//

import Foundation
import SwiftUI
import WebKit

struct MovieTrailerView: UIViewRepresentable {
    
    let movieID: Int
    let apiManager : APIManager
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(getMovieTrailerURL())") else {
            return
        }
        uiView.load(URLRequest(url: url))
    }
    
    func getMovieTrailerURL() -> String {
        var urlString = ""
        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiManager.apiKey)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { semaphore.signal() }
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(MovieTrailerResponse.self, from: data)
                    if let video = response.results.first {
                        urlString = video.key
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
        semaphore.wait()
        return urlString
    }
}

struct MovieTrailerResponse: Codable {
    let results: [MovieTrailer]
}

struct MovieTrailer: Codable {
    let key: String
}
