//
//  SplashScreenView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-22.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var loaded = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @ObservedObject var userManager = UserManager()
    
    var body: some View {
            
        VStack {
            if loaded {
                ContentView(userManager: userManager)
            } else{
                ZStack{
                    
                    Color(red: 20/255, green: 20/255, blue: 20/255)
                        .ignoresSafeArea()
                    VStack{
                        VStack{
                            Image(systemName: "film")
                                .font(.system(size: 80))
                                .foregroundColor(Color.mint.opacity(0.7))
                            Text("MoviePal")
                                .font(Font.custom("Avenir", size: 28))
                                .foregroundColor(.white)
                            VStack{
                                Image("tmdb_logo")
                                    .resizable()
                                    .frame(width: 60, height: 30)
                                Text("This product uses the TMDB API but is not endorsed or certified by TMDB")
                                    .font(Font.custom("Avenir", size: 10))
                                    .foregroundColor(.white)
                            }
                            .padding()
                        }
                        .scaleEffect(size)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.4)){
                                self.size = 0.9
                                self.opacity = 1.0
                            }
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation{
                                self.loaded = true
                            }
                        }
                    }
                }
            }
        }
                .onAppear {
                    userManager.getUser()
                }
    }
}

