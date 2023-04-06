//
//  MovieTrailerView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-04-02.
//

import Foundation
import SwiftUI
import WebKit

import MediaPlayer
import MediaAccessibility

struct MovieTrailerView: UIViewRepresentable {

    let movieID: Int
    let apiManager: APIManager

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        getMovieTrailerURL { urlString in
            guard let url = URL(string: "https://www.youtube.com/embed/\(urlString)") else {return}
            
            DispatchQueue.main.async{
                uiView.scrollView.isScrollEnabled = false
                uiView.load(URLRequest(url: url))
            }
        }
    }

    func getMovieTrailerURL(completion: @escaping (String) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiManager.apiKey)")!
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(MovieTrailerResponse.self, from: data)
                        if let video = response.results.first {
                            completion(video.key)
                        } else {
                            completion("")
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion("")
                    }
                } else {
                    print(error?.localizedDescription ?? "Unknown error")
                    completion("")
                }
            }.resume()
        }
    }
}

struct MovieTrailerResponse: Codable {
    let results: [MovieTrailer]
}

struct MovieTrailer: Codable {
    let key: String
}
