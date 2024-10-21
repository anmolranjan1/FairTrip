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

    func requestRide(ride: Ride, completion: @escaping (Bool) -> Void) {
        do {
            let _ = try db.collection("rides").addDocument(from: ride) { error in
                if let error = error {
                    print("Error adding ride: \(error)")
                    completion(false)
                } else {
                    // Save to ride history
                    let rideHistory = RideHistory(
                        id: UUID().uuidString,
                        pickupLocation: ride.pickupLocation,
                        dropOffLocation: ride.dropoffLocation,
                        timestamp: ride.timestamp,
                        driver: Driver(id: ride.driverId, name: "Dummy Driver", vehicleModel: "Dummy Model", licensePlate: "Dummy Plate", rating: 4.5, location: DriverLocation(latitude: ride.pickupLocation.latitude, longitude: ride.pickupLocation.longitude)),
                        fare: ride.fare,
                        rideStatus: .ongoing // or .completed based on your logic
                    )
                    
                    do {
                        let _ = try self.db.collection("rideHistory").addDocument(from: rideHistory)
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

    func addRide(_ ride: Ride, completion: @escaping (Error?) -> Void) {
        do {
            let _ = try db.collection("rides").document(ride.id).setData(from: ride)
            completion(nil)
        } catch let error {
            completion(error)
        }
    }

    func fetchRideHistory(for userId: String) -> AnyPublisher<[RideHistory], Error> {
        return Future { promise in
            self.db.collection("rides")
                .whereField("userId", isEqualTo: userId)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        let rideHistories = querySnapshot?.documents.compactMap { document -> RideHistory? in
                            return try? document.data(as: RideHistory.self)
                        } ?? []
                        promise(.success(rideHistories))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

}
