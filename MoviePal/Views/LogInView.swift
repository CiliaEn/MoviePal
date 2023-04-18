//
//  LogInView.swift
//  MoviePal
//
//  Created by Cilia Ence on 2023-03-22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggingIn = true
    @ObservedObject var userManager : UserManager
    
    var body: some View {
        if userManager.user != nil {
            ContentView(userManager: userManager)
                
        } else{
            VStack {
                Image(systemName: "lock.shield")
                    .font(.largeTitle)
                    .padding(.bottom, 40)
                TextField("Email", text: $email)
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
    }
    
    func login() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error logging in \(error)")
            } else {
                // Login successful
                userManager.getUser()
                print("Logging in...")
               
                
            }
        }
        
    }
    
    func signup() {
        
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print("Error signing up \(error)")
                } else {
                    let newUser = User(email: self.email)
                    print("Sign up succesful")
                    let userData = try! JSONEncoder().encode(newUser)
                    let userDictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    
                    let db = Firestore.firestore()
                    let userRef = db.collection("users").document(result!.user.uid)
                    userRef.setData(userDictionary) { (error) in
                        if let error = error {
                            print("Error saving  \(error)")
                        } else {
                            userManager.user = newUser
                            print("Signing up...")
                        }
                    }
                }
            }
        
    }
}


