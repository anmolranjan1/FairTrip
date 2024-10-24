//
//  User.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var phoneNumber: String
    var profilePictureURL: String?
    
    // Additional initializer for easier user creation
    init(id: String, name: String, email: String, phoneNumber: String, profilePictureURL: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.profilePictureURL = profilePictureURL
    }
}
