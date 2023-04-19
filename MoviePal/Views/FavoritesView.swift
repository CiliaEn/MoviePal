//
//  FavoritesView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-21.
//

import SwiftUI

struct FavoritesView: View {
    
    let apiManager : APIManager
    let userManager : UserManager
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        if let user = userManager.user {
            VStack {
                
                Text("My liked movies")
                    .font(.system(size: 22, weight: .regular))
                    
                    ScrollView{
                        LazyVGrid(columns: columns) {
                            ForEach (user.favoriteMovies) { movie in
                                
                                NavigationLink(
                                    destination: MovieInfoView(movie: movie, userManager: userManager, apiManager: apiManager),
                                    label: {
                                        ListView(movie: movie)
                                    }
                                )
                            }
                        }
                }
                Button(action: {
                    userManager.signOut()
                }) {
                    Text("Sign out")
                }
            }
            .onAppear {
                userManager.getUser()
            }
           
            
        } else {
            LogInView(userManager: userManager)
        }
    }
}
