//  RideService.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import Combine
import CoreLocation
import FirebaseFirestore

class RideService {
    private var db = Firestore.firestore()

    // Function to add a dummy driver
    func addDummyDriver() {
        let driverLocation = DriverLocation(latitude: 28.4595, longitude: 77.0266) // Example coordinates (Gurgaon)
        let driver = Driver(id: UUID().uuidString, name: "Alice Johnson", vehicleModel: "Ford Focus", licensePlate: "XYZ 5678", rating: 4.7, location: driverLocation)
        
        do {
            let _ = try db.collection("drivers").addDocument(from: driver)
            print("Driver added successfully!")
        } catch {
            print("Error adding driver: \(error)")
        }
    }

    // Function to add a dummy ride
    func addDummyRide() {
        let pickupLocation = CLLocationCoordinate2D(latitude: 28.4742, longitude: 77.1159) // Example coordinates (Faridabad)
        let dropoffLocation = CLLocationCoordinate2D(latitude: 28.6431, longitude: 77.2225) // Example coordinates (Greater Noida)
        
        let ride = Ride(id: UUID().uuidString, userId: "user_id_example", pickupLocation: pickupLocation, dropoffLocation: dropoffLocation, timestamp: Date(), fare: 300.0, driverId: "driver_id_example_2")

        do {
            let _ = try db.collection("rides").addDocument(from: ride)
            print("Ride added successfully!")
        } catch {
            print("Error adding ride: \(error)")
        }
    }

    // Function to add dummy ride history
    func addDummyRideHistory() {
        let pickupLocation = CLLocationCoordinate2D(latitude: 28.6431, longitude: 77.2225) // Example coordinates (Greater Noida)
        let dropoffLocation = CLLocationCoordinate2D(latitude: 28.4595, longitude: 77.0266) // Example coordinates (Gurgaon)
        
        let driver = Driver(id: "driver_id_example_2", name: "Alice Johnson", vehicleModel: "Ford Focus", licensePlate: "XYZ 5678", rating: 4.7, location: DriverLocation(latitude: 28.4595, longitude: 77.0266))

        let rideHistory = RideHistory(id: UUID().uuidString, pickupLocation: pickupLocation, dropOffLocation: dropoffLocation, timestamp: Date(), driver: driver, fare: 300.0, rideStatus: .completed)

        do {
            let _ = try db.collection("rideHistory").addDocument(from: rideHistory)
            print("Ride history added successfully!")
        } catch {
            print("Error adding ride history: \(error)")
        }
    }
    
    
    // Simulated fetching available drivers
    func fetchAvailableDrivers() -> AnyPublisher<[Driver], Error> {
        // Simulate network delay and return a mock list of drivers
        let drivers = [
            Driver(id: "1", name: "John Doe", vehicleModel: "Toyota Camry", licensePlate: "XYZ 1234", rating: 4.5, location: DriverLocation(latitude: 12.9716, longitude: 77.5946)),
            Driver(id: "2", name: "Jane Smith", vehicleModel: "Honda Accord", licensePlate: "ABC 5678", rating: 4.8, location: DriverLocation(latitude: 12.2958, longitude: 76.6393))
        ]
        
        return Just(drivers)
            .delay(for: 1.0, scheduler: DispatchQueue.global())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    // Simulated ride request to a backend
    func requestRide(ride: Ride) -> AnyPublisher<Bool, Error> {
        // Simulate a network delay
        return Just(true) // Simulating success
            .delay(for: 1.0, scheduler: DispatchQueue.global())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    // Simulated ride history fetch from a backend (Firebase or other)
    func fetchRideHistory(for userId: String) -> AnyPublisher<[RideHistory], Error> {
        let rideHistories: [RideHistory] = [
            RideHistory(id: "1", pickupLocation: CLLocationCoordinate2D(latitude: 12.9716, longitude: 77.5946), dropOffLocation: CLLocationCoordinate2D(latitude: 12.2958, longitude: 76.6393), timestamp: Date(), driver: Driver(id: "1", name: "John Doe", vehicleModel: "Toyota Camry", licensePlate: "XYZ 1234", rating: 4.5, location: DriverLocation(latitude: 12.9716, longitude: 77.5946)), fare: 150.0, rideStatus: .completed)
        ]
        
        return Just(rideHistories)
            .delay(for: 1.0, scheduler: DispatchQueue.global())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
