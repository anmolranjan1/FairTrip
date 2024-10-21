//
//  RideHistory.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import CoreLocation

struct RideHistory: Identifiable, Codable {
    var id: String // Unique identifier for the ride
    var pickupLocation: CLLocationCoordinate2D // Pickup location for the ride
    var dropOffLocation: CLLocationCoordinate2D // Drop-off location for the ride
    var timestamp: Date // Date and time of the ride
    var driver: Driver // The driver for this ride
    var fare: Double // Fare for the ride
    var rideStatus: RideStatus // Status of the ride (completed, ongoing, etc.)

    // Custom CodingKeys to handle encoding and decoding
    enum CodingKeys: String, CodingKey {
        case id
        case pickupLocation
        case dropOffLocation
        case timestamp
        case driver
        case fare
        case rideStatus
    }
}

// Enum to represent the status of the ride
enum RideStatus: String, Codable {
    case completed
    case ongoing
    case canceled
}
