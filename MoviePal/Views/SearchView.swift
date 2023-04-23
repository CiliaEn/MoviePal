//
//  SearchView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-21.
//

import SwiftUI

struct SearchView: View {
    
    let apiManager : APIManager
    let userManager : UserManager
    @State var searchText = ""
 
    
    var searchResults: [Movie] {
        if searchText.isEmpty {
            let emptyList = [Movie]()
            return emptyList
        } else {
            apiManager.loadMovies(searchWord: searchText)
            return apiManager.movies
        }
    }
    
    var body: some View {
        
        ZStack{
            Color(red: 20/255, green: 20/255, blue: 20/255)
                .ignoresSafeArea()
            
            VStack {
                
                List {
                    ForEach(searchResults, id: \.self) { movie in
                        NavigationLink(
                            destination: MovieInfoView(movie: movie, userManager: userManager, apiManager: apiManager),
                            label: {
                                SearchItemView(movie: movie)
                            }
                        )
                    }
                    
                }
            }
            .searchable(text: $searchText)
            
            
        }
    }
  
}

