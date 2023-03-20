//
//  ContentView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-20.
//

import SwiftUI

struct ContentView: View {
    
    
    var body: some View {
        TabView {
            
            PopularMoviesView()
                .tabItem {
                    Label("First", systemImage: "1.circle")
                }
            SearchView()
                .tabItem {
                    Label("Second", systemImage: "2.circle")
                }
            FavoriteView()
                .tabItem {
                    Label("Third", systemImage: "3.circle")
                }
        }
        .onAppear {
            APIManager().loadData()
        }
    }
}

struct PopularMoviesView: View {
    
    var body: some View {
        Text("Popular Movies View")
    }
}

struct SearchView: View {
    
    var body: some View {
        Text("Search view")
    }
}

struct FavoriteView: View {
    
    var body: some View {
        Text("Favorite View")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
