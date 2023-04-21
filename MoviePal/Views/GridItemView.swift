//
//  GridItemView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-04-19.
//

import SwiftUI

struct GridItemView: View {
    
    let movie: Movie
    
    @State private var posterImage: UIImage?
    
    var body: some View {
      
            VStack {
                if let image = posterImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 120)
                        .cornerRadius(10)
                } else {
                    Color.gray
                        .frame(width: 80, height: 120)
                        .cornerRadius(10)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.black)
                    Text(String(format: "%.1f", movie.imdbScore))
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .onAppear {
                loadPoster(movie: movie) { image in
                            if let image = image {
                                self.posterImage = image
                            }
                        }
            }
        
    }
    
    
}
