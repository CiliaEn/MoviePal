//
//  LogInView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-22.
//

import SwiftUI

struct LogInView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggingIn = true
    
    var body: some View {
        VStack {
            Image(systemName: "lock.shield")
                .font(.largeTitle)
                .padding(.bottom, 40)
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Button(action: {
                // Login or signup button action
                if isLoggingIn {
                    login()
                } else {
                    signup()
                }
            }) {
                Text(isLoggingIn ? "Login" : "Signup")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5.0)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            Button(action: {
                isLoggingIn.toggle()
            }) {
                Text(isLoggingIn ? "Don't have an account? Signup" : "Already have an account? Login")
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 30)
        }
        .padding()
    }
    
    func login() {
        // Add code to perform login
        print("Logging in...")
    }
    
    func signup() {
        // Add code to perform signup
        print("Signing up...")
    }
}


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
