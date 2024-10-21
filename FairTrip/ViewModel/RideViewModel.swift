//
//  RideViewModel.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import Combine
import CoreLocation

class RideViewModel: ObservableObject {
    @Published var pickupLocation: CLLocationCoordinate2D? {
           didSet {
               calculateFare() // Recalculate fare when pickup changes
           }
       }
    @Published var dropoffLocation: CLLocationCoordinate2D? {
            didSet {
                calculateFare() // Recalculate fare when dropoff changes
            }
        }
    @Published var rideHistory: [Ride] = []
    @Published var selectedDriver: Driver?
    @Published var fare: Double = 0.0
    @Published var timestamp: Date = Date()
    @Published var errorMessage: String?
    @Published var availableDrivers: [Driver] = [] // Store available drivers

    private var cancellables = Set<AnyCancellable>()
    private let rideService: RideService
    private let authService: AuthService
    
    init(rideService: RideService, authService: AuthService) {
        self.rideService = rideService
        self.authService = authService
    }
    
    // Calculate fare based on pickup and dropoff locations
    func calculateFare() {
        guard let pickup = pickupLocation, let dropoff = dropoffLocation else {
            errorMessage = "Pickup and dropoff locations must be set."
            return
        }

        // Create CLLocation instances for distance calculation
        let pickupCLLocation = CLLocation(latitude: pickup.latitude, longitude: pickup.longitude)
        let dropoffCLLocation = CLLocation(latitude: dropoff.latitude, longitude: dropoff.longitude)

        let distance = pickupCLLocation.distance(from: dropoffCLLocation) / 1000 // Convert to kilometers
        let baseFare = 5.0 // Example base fare
        let perKmFare = 2.0 // Example fare per kilometer

        fare = baseFare + (distance * perKmFare)
    }

    // Request a ride
    func requestRide() {
        guard let pickup = pickupLocation, let dropoff = dropoffLocation else {
            errorMessage = "Please set both pickup and dropoff locations."
            return
        }

        let ride = Ride(id: UUID().uuidString,
                        userId: authService.user?.id ?? "", // Ensure the correct user ID
                        pickupLocation: pickup,
                        dropoffLocation: dropoff,
                        timestamp: timestamp,
                        fare: fare,
                        driver: selectedDriver) // Updated driver ID

        rideService.requestRide(ride: ride) { success in
            if success {
                // Optionally fetch ride history after successful booking
                self.fetchRideHistory()
            } else {
                self.errorMessage = "Failed to book ride."
            }
        }
    }

//    // Fetch ride history for the logged-in user
    func fetchRideHistory() {
        guard let userId = authService.user?.id else {
            errorMessage = "User not logged in."
            return
        }
        
        rideService.fetchRideHistory(for: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { rideHistories in
                self.rideHistory = rideHistories.map { history in
                    Ride(id: history.id,
                         userId: userId, // Set user ID here
                         pickupLocation: history.pickupLocation,
                         dropoffLocation: history.dropoffLocation,
                         timestamp: history.timestamp,
                         fare: history.fare,
                         driver: history.driver) // Ensure driver exists
                }
            })
            .store(in: &cancellables)
    }
    
//    // Fetch ride history for the user
//    func fetchRideHistory() {
//        guard let userId = authService.user?.id else {
//            errorMessage = "User ID is not available."
//            return
//        }
//
//        rideService.fetchRideHistory(for: userId)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .failure(let error):
//                    self.errorMessage = "Error fetching ride history: \(error.localizedDescription)"
//                case .finished:
//                    break
//                }
//            }, receiveValue: { rides in
//                self.rideHistory = rides
//            })
//            .store(in: &cancellables)
//    }

    // Load available drivers
    func fetchAvailableDrivers() {
        rideService.fetchAvailableDrivers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { drivers in
                self.availableDrivers = drivers
            })
            .store(in: &cancellables)
    }
    
    // Save ride
    func saveRide(_ ride: Ride, completion: @escaping (Bool) -> Void) {
        rideService.addRide(ride) { error in
            if let error = error {
                print("Error adding ride: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
