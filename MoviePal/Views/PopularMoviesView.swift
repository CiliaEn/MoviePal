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
  //  @State var movies = [Movie]()

    @State var selectedSortingOption = "Title"
    
    var sortedMovies: [Movie] {
        switch selectedSortingOption {
        case "IMDb Score":
            return apiManager.movies.sorted { $0.imdbScore > $1.imdbScore }
        case "Release Date":
            return apiManager.movies.sorted { $0.releaseDate > $1.releaseDate }
        default:
           // apiManager.loadData()
            return apiManager.movies
        }
    }
    
    var body: some View {
        VStack{
            FilterView(selectedOption: $selectedSortingOption)
            List {
                ForEach(sortedMovies) { movie in
                   
                    NavigationLink(
                        destination: MovieView(movie: movie, userManager: userManager),
                        label: {
                            ListView(movie: movie)
                        }
                    )
                }
            }
            .onAppear {
                apiManager.loadData()
               // loadFavorites()
                
            }
        }
        
       
    }
    
//    func loadFavorites() {
//
//            for apiMovie in sortedMovies {
//
//                var movie = Movie(id: apiMovie.id, title: apiMovie.title, overview: apiMovie.overview, posterURL: apiMovie.posterURL, releaseDate: apiMovie.releaseDate, imdbScore: apiMovie.imdbScore)
//
//                if let user = userManager.user {
//                for userMovie in user.favoriteMovies {
//                    if apiMovie == userMovie {
//                        movie.isFavorite = true
//                        break
//                    }
//                }
//            }
//                movies.append(movie)
//        }
//
//    }
    
}

struct ListView : View {

    let movie : Movie

    var body: some View {
        HStack{
            Text(movie.title)
            Text(String(format: "%.1f", movie.imdbScore))
        }
        
    }
}

struct MovieView : View {

    @State var movie : Movie
   
    let userManager : UserManager
    
    var body: some View {
        Text(movie.title)
        Button(action: {
            if let user = userManager.user{
                // (movie.isFavorite).toggle()
                
                if (user.checkForFavorite(movie: movie)) {
                    user.removeMovie(movie: movie)
                } else {
                    user.addMovie(movie: movie)
                }
                userManager.saveUserToFirestore()
            } else {
                print("You have to log in to favorite movies")
            }
        }) {            if let user = userManager.user{
                Image(systemName: user.checkForFavorite(movie: movie) ? "heart.fill" : "heart")
            } else {
                Image(systemName: "heart")
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
