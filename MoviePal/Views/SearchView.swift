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
            apiManager.loadData(searchWord: searchText)
            return apiManager.movies
        }
    }
    
    var body: some View {
        VStack {
            
            List {
                ForEach(searchResults, id: \.self) { movie in
                    NavigationLink(
                        destination: MovieView(movie: movie, userManager: userManager, apiManager: apiManager),
                        label: {
                            ListView(movie: movie)
                        }
                    )
                }
                
            }
        }
        .searchable(text: $searchText)
        .onAppear {
          //  apiManager.loadData(searchWord: searchText)
         
   
        }
    }
  
}

