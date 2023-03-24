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
    
    @ObservedObject var userManager : UserManager
    @ObservedObject var apiManager = APIManager()
    
    var body: some View {
        VStack{
            
            TabView {
                NavigationView {
                    PopularMoviesView( apiManager: apiManager, userManager: userManager)
                }
                .tabItem {
                    Label("First", systemImage: "1.circle")
                }
                
                NavigationView {
                    SearchView(apiManager: apiManager, userManager: userManager)
                }
                .tabItem {
                    Label("Second", systemImage: "2.circle")
                }
                NavigationView {
                    FavoritesView(apiManager: apiManager, userManager: userManager)
                }
                .tabItem {
                    Label("Third", systemImage: "3.circle")
                }
            }
        }
        .onAppear {
            apiManager.loadData()
            userManager.getUser()
        }
    }
}








