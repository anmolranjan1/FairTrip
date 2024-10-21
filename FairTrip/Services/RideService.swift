//
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
    func addDummyRide(userId: String) {
        let pickupLocation = CLLocationCoordinate2D(latitude: 28.4742, longitude: 77.1159) // Example coordinates (Faridabad)
        let dropoffLocation = CLLocationCoordinate2D(latitude: 28.6431, longitude: 77.2225) // Example coordinates (Greater Noida)

        // Fetch a dummy driver for the ride
        let driverLocation = DriverLocation(latitude: 28.4595, longitude: 77.0266) // Example driver location
        let driver = Driver(id: UUID().uuidString, name: "Alice Johnson", vehicleModel: "Ford Focus", licensePlate: "XYZ 5678", rating: 4.7, location: driverLocation)

        let ride = Ride(
            id: UUID().uuidString,
            userId: userId,
            pickupLocation: pickupLocation,
            dropoffLocation: dropoffLocation,
            timestamp: Date(),
            fare: 300.0,
            driver: driver // Use the Driver object directly
        )

        do {
            let _ = try db.collection("rides").addDocument(from: ride)
            print("Ride added successfully!")
        } catch {
            print("Error adding ride: \(error)")
        }
    }
    
    // Fetch available drivers
    func fetchAvailableDrivers() -> AnyPublisher<[Driver], Error> {
        return Future { promise in
            self.db.collection("drivers").getDocuments { (snapshot, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                guard let documents = snapshot?.documents else {
                    promise(.success([]))
                    return
                }
                let drivers = documents.compactMap { try? $0.data(as: Driver.self) }
                promise(.success(drivers))
            }
        }
        .eraseToAnyPublisher()
    }

    // Request a ride and save to ride history
    func requestRide(ride: Ride, completion: @escaping (Bool) -> Void) {
        do {
            let _ = try db.collection("rides").addDocument(from: ride) { error in
                if let error = error {
                    print("Error adding ride: \(error)")
                    completion(false)
                } else {
                    // Save to ride history (same collection)
                    do {
                        let _ = try self.db.collection("rides").addDocument(from: ride)
                        print("Ride history added successfully!")
                        completion(true)
                    } catch {
                        print("Error adding ride history: \(error)")
                        completion(false)
                    }
                }
            }
        } catch {
            print("Error adding ride: \(error)")
            completion(false)
        }
    }

    // Add a ride
    func addRide(_ ride: Ride, completion: @escaping (Error?) -> Void) {
        do {
            let _ = try db.collection("rides").document(ride.id!).setData(from: ride)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }

    func fetchRideHistory(for userId: String) -> AnyPublisher<[Ride], Error> {
        print("Fetching ride history for user: \(userId)")
        return Future { promise in
            self.db.collection("rides") // Querying the same collection for ride history
                .whereField("userId", isEqualTo: userId)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        let rides = querySnapshot?.documents.compactMap { document -> Ride? in
                            return try? document.data(as: Ride.self)
                        } ?? []
                        print("Fetched rides: \(rides)") // Debugging line
                        promise(.success(rides))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
