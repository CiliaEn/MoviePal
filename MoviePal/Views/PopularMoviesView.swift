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
            FilterView(selectedOption: $selectedSortingOption)
           
                ScrollView{
                    LazyVGrid(columns: columns) {

                        ForEach(sortedMovies) { movie in

                        NavigationLink(
                            destination: MovieView(movie: movie, userManager: userManager, apiManager: apiManager),
                            label: {
                                ListView(movie: movie)
                            }
                        )
                                   }
                    }
                }
            }
        .onAppear {
            userManager.getUser()
        }
    }
}

struct ListView: View {
    
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
            loadPoster()
        }
    }
    
    func loadPoster() {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w185\(movie.posterURL)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error loading poster image: \(error.localizedDescription)")
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.posterImage = image
                }
            } else {
                print("Error loading poster image")
            }
        }
        task.resume()
    }
}

struct MovieView: View {
    
    @State var movie: Movie
    let userManager: UserManager
    let apiManager: APIManager
    
    @State private var showAllActors = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            HStack{
                VStack{
                    MovieTrailerView(movieID: movie.id, apiManager: apiManager)
                }
            }
            Text(movie.title)
                .font(.title)
            Text(movie.overview)
                .font(.body)
            Text("Release Date: \(movie.releaseDate)")
                .font(.body)
            HStack {
                Text("IMDb Score:")
                    .font(.body)
                Text(String(format: "%.1f", movie.imdbScore))
                    .font(.body)
            }
            Text("Genre")
                .font(.body)
            Text("Actors: " + (showAllActors ? movie.actors.joined(separator: ", ") : movie.actors.prefix(6).joined(separator: ", ")))
                .font(.body)
                .lineLimit(nil)
                .onTapGesture {
                    self.showAllActors.toggle()
                }
            
            Button(action: {
                if let user = userManager.user {
                    if (user.checkForFavorite(movie: movie)) {
                        print("removeMovie")
                        user.removeMovie(movie: movie)
                    } else {
                        print("addMovie")
                        user.addMovie(movie: movie)
                    }
                    userManager.saveUserToFirestore()
                } else {
                    print("You have to log in to favorite movies")
                }
            }) {
                if let user = userManager.user {
                    if user.checkForFavorite(movie: movie) {
                        Image(systemName: "heart.fill")
                    } else {
                        Image(systemName: "heart")
                    }
                } else {
                    Image(systemName: "heart")
                }
            }
        }
        .onAppear {
            userManager.getUser()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
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
