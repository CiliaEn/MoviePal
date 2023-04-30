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
    @State private var showAlert = false
    @State private var logInAlert = true
    
    var body: some View {
        
            if userManager.user != nil {
                ContentView(userManager: userManager)
            } else{
                ZStack{
                    Color(red: 20/255, green: 20/255, blue: 20/255)
                        .ignoresSafeArea()
                    VStack {
                        Image(systemName: "lock.shield")
                            .font(.largeTitle)
                            .padding(.bottom, 40)
                            .foregroundColor(Color.mint.opacity(0.8))
                        Text(isLoggingIn ? "LOG IN" : "SIGN UP")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.white.opacity(0.75))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.75))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                            .padding(.horizontal, 20)
                        Button(action: {
                            isLoggingIn ? login() : signup()
                           
                        }) {
                            Text(isLoggingIn ? "LOG IN" : "SIGN UP")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.mint.opacity(0.7))
                                .cornerRadius(5.0)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 5)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(logInAlert ? "Invalid email or password. Please try again." : "Something went wrong trying to sign up. Please try again." ), dismissButton: .default(Text("OK")))
                                }
                        Button(action: {
                            isLoggingIn.toggle()
                        }) {
                            Text(isLoggingIn ? "Don't have an account? Signup" : "Already have an account? Login")
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 30)
                    }
                    .padding()
                }
            }
        }
    
    func login() {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                logInAlert = true
                showAlert = true
            } else {
                userManager.getUser()
            }
        }
    }
    
    func signup() {
        
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    logInAlert = false
                    showAlert = true
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


