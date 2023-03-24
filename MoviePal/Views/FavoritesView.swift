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
    
    var body: some View {
        if let user = userManager.user {
            VStack {
                List {
                    ForEach (user.favoriteMovies) { movie in
                        ListView(movie: movie)
                    }
                }
            }
           // .onAppear {
            //    userManager.signOut()
          //  }
            
        }
    }
}
