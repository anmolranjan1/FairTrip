//
//  Driver.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import FirebaseFirestore

struct Driver: Identifiable, Codable {
    @DocumentID var id: String? // Unique identifier for the driver
    var name: String // Driver's name
    var vehicleModel: String // Model of the vehicle driven by the driver
    var licensePlate: String // License plate number of the vehicle
    var rating: Double? // Optional driver rating
    var location: DriverLocation // Driver's current location

    // Custom CodingKeys to handle encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case vehicleModel
        case licensePlate
        case rating
        case location
    }
}

// Struct to represent driver's location
struct DriverLocation: Codable {
    var latitude: Double // Latitude of the driver's current location
    var longitude: Double // Longitude of the driver's current location

    // Custom CodingKeys to handle encoding and decoding
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}
