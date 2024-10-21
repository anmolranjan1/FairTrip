//
//  RideHistory.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import CoreLocation

struct Ride: Identifiable, Codable {
    var id: String
    var userId: String // ID of the user who requested the ride
    var pickupLocation: CLLocationCoordinate2D // Pickup location coordinates
    var dropoffLocation: CLLocationCoordinate2D // Drop-off location coordinates
    var timestamp: Date // Timestamp of when the ride was requested
    var fare: Double // Optional fare for the ride
    var driverId: String // Optional driver ID if a driver is assigned

    // Custom CodingKeys to handle encoding and decoding of CLLocationCoordinate2D
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case pickupLocation
        case dropoffLocation
        case timestamp
        case fare
        case driverId
    }
}

// Extension to encode and decode CLLocationCoordinate2D
extension CLLocationCoordinate2D: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.latitude, forKey: .latitude)
        try container.encode(self.longitude, forKey: .longitude)
    }

    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
}

