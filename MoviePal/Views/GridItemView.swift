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
                        .frame(width: 110, height: 146)
                        .cornerRadius(10)
                } else {
                    Color.gray
                        .frame(width: 80, height: 120)
                        .cornerRadius(10)
                }
                HStack {
                    Text(movie.title)
                        .font(.system(size: 10, weight: .regular))
                        .foregroundColor(.white)
                        .layoutPriority(1)
                    Spacer()
                    Circle()
                        .stroke(Color.white, lineWidth: 0.5)
                        .frame(width: 15, height: 15)
                        .overlay(
                            Text(String(format: "%.1f", movie.imdbScore))
                                .font(.system(size: 8, weight: .regular))
                                .foregroundColor(.white)
                        )
                        .padding(.trailing, 5)
                }
                
            }
            .frame(width: 108, height: 180)
            .padding(5)
            .onAppear {
                loadPoster(movie: movie) { image in
                            if let image = image {
                                self.posterImage = image
                            }
                        }
            }
        
    }
    
    
}
