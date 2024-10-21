//  ProfileViewModel.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    // Fetch user profile
    func fetchProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is currently logged in.")
            return
        }
        
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                self?.user = try? document.data(as: User.self)
                self?.name = self?.user?.name ?? ""
                self?.email = self?.user?.email ?? ""
                self?.phone = self?.user?.phoneNumber ?? ""
                print("Fetched user: \(String(describing: self?.user))") // Debugging statement
            } else {
                print("User document does not exist: \(String(describing: error))")
            }
        }
    }
    
    // Load image from URL
    func loadImage(from url: String) -> UIImage? {
        guard let imageUrl = URL(string: url) else { return nil }
        let data = try? Data(contentsOf: imageUrl)
        if let imageData = data {
            return UIImage(data: imageData)
        }
        return nil
    }

    // Update user profile
    func updateProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        updateProfile(userId: userId, name: name, phoneNumber: phone)
    }

    // Upload profile image
    func uploadProfileImage(_ image: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        uploadProfilePicture(userId: userId, imageData: imageData)
    }

    private func updateProfile(userId: String, name: String, phoneNumber: String?) {
        db.collection("users").document(userId).updateData([
            "name": name,
            "phoneNumber": phoneNumber ?? ""
        ]) { error in
            if let error = error {
                print("Error updating profile: \(error)")
            }
        }
    }

    // Change access level to internal or public
    func uploadProfilePicture(userId: String, imageData: Data) {
        let storageRef = storage.reference().child("profile_pictures/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading profile picture: \(error)")
            } else {
                storageRef.downloadURL { [weak self] url, error in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                    } else if let url = url {
                        self?.db.collection("users").document(userId).updateData([
                            "profilePictureURL": url.absoluteString
                        ])
                    }
                }
            }
        }
    }
}
