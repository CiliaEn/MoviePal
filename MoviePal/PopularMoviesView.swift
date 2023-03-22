//
//  PopularMoviesView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-21.
//

import SwiftUI

struct PopularMoviesView: View {

    @ObservedObject var manager = APIManager()

    @State var selectedSortingOption = "Title"

    var sortedMovies: [Movie] {
        switch selectedSortingOption {
        case "IMDb Score":
            return manager.movies.sorted { $0.imdbScore > $1.imdbScore }
        //case "Release Date":
      //      return manager.movies.sorted { $0.releaseDate > $1.releaseDate }
        default:
            return manager.movies
        }
    }

    var body: some View {
        VStack{
            FilterView(selectedOption: $selectedSortingOption)
            List {
                ForEach(sortedMovies) { movie in
                    NavigationLink(
                        destination: MovieView(movie: movie),
                        label: {
                            ListView(movie: movie)
                        }
                    )
                }
            }
        }
        .onAppear {
            manager.loadData()
        }
    }
}

struct ListView : View {

    let movie : Movie

    var body: some View {
        Text(movie.title)
        Text(String(format: "%.1f", movie.imdbScore))
        
    }
}

struct MovieView : View {

    let movie : Movie
    @State private var isFilled = false
    
    var body: some View {
        Text(movie.title)
        Button(action: {
            self.isFilled.toggle()
            // isFilled ?  addToFavorites() : removeFromFavorites()
        }) {
            Image(systemName: isFilled ? "heart.fill" : "heart")
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

struct PopularMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesView()
    }
}
