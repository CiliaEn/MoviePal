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
                            destination: MovieInfoView(movie: movie, userManager: userManager, apiManager: apiManager),
                            label: {
                                ListView(movie: movie)
                            }
                        )
                                   }
                    }
                }
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
