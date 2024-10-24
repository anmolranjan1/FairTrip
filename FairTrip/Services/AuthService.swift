//
//  AuthService.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Combine

class AuthService: ObservableObject {
    @Published var user: User? // Current user
    private let db = Firestore.firestore()
    
    // Sign up a new user with email, password, name, and phone number
    func signUp(email: String, password: String, name: String, phone: String) -> AnyPublisher<User, Error> {
        return Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let firebaseUser = authResult?.user else {
                    promise(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User creation failed."])))
                    return
                }
                
                // Send email verification
                firebaseUser.sendEmailVerification { error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    // Create the User object with phone number
                    let newUser = User(id: firebaseUser.uid, name: name, email: firebaseUser.email ?? "", phoneNumber: phone)
                    
                    // Store the user's data in Firestore, including phone number
                    self.db.collection("users").document(newUser.id!).setData([
                        "name": newUser.name,
                        "email": newUser.email,
                        "phoneNumber": newUser.phoneNumber, // Store the phone number here
                        "profilePictureURL": newUser.profilePictureURL ?? ""
                    ]) { error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        
                        // If storing the user in Firestore is successful, return the User object
                        promise(.success(newUser))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Log in an existing user with email and password
    func login(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    promise(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User login failed."])))
                    return
                }
                
                let currentUser = User(id: user.uid, name: "", email: user.email ?? "", phoneNumber: "")
                promise(.success(currentUser))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Check if the user is currently logged in
    func checkCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            self.user = User(id: currentUser.uid, name: "", email: currentUser.email ?? "", phoneNumber: "")
        }
    }
    
    // Log out the current user
    func logout() {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
