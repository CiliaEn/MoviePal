//
//  PopularMoviesView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-21.
//

import SwiftUI

struct PopularMoviesView: View {

    @ObservedObject var apiManager : APIManager
    @ObservedObject var userManager : UserManager

    @State var selectedSortingOption = "Title"
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var sortedMovies: [Movie] {
        switch selectedSortingOption {
        case "IMDb Score":
            return apiManager.movies.sorted { $0.imdbScore > $1.imdbScore }
        case "Release Date":
            return apiManager.movies.sorted { $0.releaseDate > $1.releaseDate }
        default:
            return apiManager.movies
        }
    }
    
    var body: some View {
       
            VStack{
                HStack{
                    Spacer()
                    FilterView(selectedOption: $selectedSortingOption)
                }
                ScrollView{
                    LazyVGrid(columns: columns) {
                        
                        ForEach(sortedMovies) { movie in
                            
                            NavigationLink(
                                destination: MovieInfoView(movie: movie, userManager: userManager, apiManager: apiManager),
                                label: {
                                    GridItemView(movie: movie)
                                }
                            )
                        }
                    }
                }
            }
        
        
    }
}





struct FilterView: View {
    let sortingOptions = ["Title", "IMDb Score", "Release Date"]
    @Binding var selectedOption: String

    var body: some View {
        HStack {
            Text("Sort by:")
            Picker(selection: $selectedOption, label: Text("")) {
                ForEach(sortingOptions, id: \.self) { option in
                    Text(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .padding(.horizontal)
    }
}
