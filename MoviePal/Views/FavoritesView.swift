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
            
            ZStack {
                
                Color(red: 20/255, green: 20/255, blue: 20/255)
                    .ignoresSafeArea()
                VStack {
                    HStack{
                        Text("Liked Movies")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    Spacer()
                    if (user.favoriteMovies.isEmpty){
                        Text("You have not liked any movies.")
                            .foregroundColor(.white)
                    } else{
                    
                        ScrollView{
                            LazyVGrid(columns: columns) {
                                ForEach (user.favoriteMovies) { movie in
                                    
                                    NavigationLink(
                                        destination: MovieInfoView(movie: movie, userManager: userManager, apiManager: apiManager),
                                        label: {
                                            GridItemView(movie: movie)
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                    Button(action: {
                        userManager.signOut()
                    }) {
                        Text("Sign out")
                            .foregroundColor(.white)
                            .frame( maxHeight: 5)
                            .padding()
                            .background(Color.mint.opacity(0.7))
                            .cornerRadius(5.0)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 5)
                    
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
