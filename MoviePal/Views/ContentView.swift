//
//  ContentView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-20.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

struct ContentView: View {
    @ObservedObject var userManager: UserManager
    @ObservedObject var apiManager = APIManager()
    
    var body: some View {
        
       
        VStack{
            TabView {
                
                NavigationStack {
                    Text("MoviePal")
                    PopularMoviesView(apiManager: apiManager, userManager: userManager)
                }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                
                NavigationStack {
                    SearchView(apiManager: apiManager, userManager: userManager)
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
                NavigationStack {
                    FavoritesView(apiManager: apiManager, userManager: userManager)
                }
                .tabItem {
                    Label("Favorites", systemImage: "heart")
                }
            }
            
        }
            .onAppear {
                userManager.getUser()
            }
            
        }
}








