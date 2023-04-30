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
    
    let columns = [GridItem(.flexible())]
 
    var searchResults: [Movie] {
        if searchText.isEmpty {
            let emptyList = [Movie]()
            return emptyList
        } else {
            apiManager.loadMovies(searchWord: searchText, type: "search")
            return apiManager.searchResults
        }
    }
    
    var body: some View {
        
        ZStack{
            Color(red: 20/255, green: 20/255, blue: 20/255)
                .ignoresSafeArea()
            
            VStack {
                if (searchText.isEmpty){
                VStack{
                    HStack {
                        Text("Top Rated On IMDb")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold))
                            .padding(.leading)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal){
                        LazyHGrid(rows: columns, spacing: 8) {
                            
                            ForEach(apiManager.topRatedMovies) { movie in
                                
                                NavigationLink(
                                    destination: MovieInfoView(movie: movie, userManager: userManager, apiManager: apiManager),
                                    label: {
                                        GridItemView(movie: movie)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 200)
                }
                    VStack{
                        HStack {
                            Text("Now playing in theaters")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .bold))
                                .padding(.leading)
                            Spacer()
                        }
                        ScrollView(.horizontal){
                            LazyHGrid(rows: columns, spacing: 8) {
                                
                                ForEach(apiManager.nowPlayingMovies) { movie in
                                    
                                    NavigationLink(
                                        destination: MovieInfoView(movie: movie, userManager: userManager, apiManager: apiManager),
                                        label: {
                                            GridItemView(movie: movie)
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                        .frame(height: 200)
                    }
                    } else {
                        VStack{
                            ScrollView(.vertical) {
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
                        
                              
                    }
                Spacer()
                }
            
            }
        
            .searchable(text: $searchText)
            .foregroundColor(Color.white)
        }
    }
  

