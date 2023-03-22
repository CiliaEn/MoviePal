//
//  SearchView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-21.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var manager = APIManager()
    @State var searchText = ""
    
    var searchResults: [Movie] {
        if searchText.isEmpty {
            manager.loadData()
            return manager.movies
        } else {
            manager.loadData(searchWord: searchText)
            return manager.movies
        }
    }
    
    var body: some View {
        VStack {
            
            List {
                ForEach(searchResults, id: \.self) { movie in
                    NavigationLink(
                        destination: MovieView(movie: movie),
                        label: {
                            ListView(movie: movie)
                        }
                    )
                }
            }
        }
        .searchable(text: $searchText)
        .onAppear {
            manager.loadData(searchWord: searchText)
        }
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
