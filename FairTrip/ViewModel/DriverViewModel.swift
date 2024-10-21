//
//  DriverViewModel.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import CoreLocation

class DriverViewModel: ObservableObject {
    @Published var driver: Driver?

    // Mock driver details for demonstration
    func assignDriver() {
        let driverLocation = DriverLocation(latitude: 37.7749, longitude: -122.4194)
        let driver = Driver(
            id: UUID().uuidString,
            name: "John Doe",
            vehicleModel: "Toyota Prius",
            licensePlate: "ABC-1234",
            rating: 4.5, // Add a rating
            location: driverLocation
        )

        DispatchQueue.main.async {
            self.driver = driver
        }
    }
}
