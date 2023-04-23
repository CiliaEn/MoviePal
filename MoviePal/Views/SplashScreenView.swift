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
                    VStack{
                        VStack{
                            Image(systemName: "camera.macro")
                                .font(.system(size: 80))
                                .foregroundColor(Color(red: 0.86, green: 0.64, blue: 1.13))
                            Text("MoviePal")
                                .font(Font.custom("Avenir", size: 26))
                                .foregroundColor(.black.opacity(0.80))
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
            .onAppear {
                userManager.getUser()
            }
       
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
