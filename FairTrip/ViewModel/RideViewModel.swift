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
    @Published var pickupLocation: CLLocationCoordinate2D?
    @Published var dropoffLocation: CLLocationCoordinate2D?
    @Published var rideHistory: [Ride] = []
    @Published var selectedDriver: Driver?
    @Published var fare: Double = 0.0
    @Published var timestamp: Date = Date()
    @Published var errorMessage: String?
    @Published var availableDrivers: [Driver]? // Store available drivers

    private var cancellables = Set<AnyCancellable>()
    private let rideService: RideService
    private let authService: AuthService
    
    init(rideService: RideService, authService: AuthService) {
        self.rideService = rideService
        self.authService = authService
    }
    
    // Calculate fare based on pickup and dropoff locations
    // Calculate fare based on pickup and dropoff locations
    func calculateFare() {
        guard let pickup = pickupLocation, let dropoff = dropoffLocation else {
            errorMessage = "Pickup and dropoff locations must be set."
            return
        }

        // Create CLLocation instances for distance calculation
        let pickupLocation = CLLocation(latitude: pickup.latitude, longitude: pickup.longitude)
        let dropoffLocation = CLLocation(latitude: dropoff.latitude, longitude: dropoff.longitude)

        let distance = pickupLocation.distance(from: dropoffLocation) / 1000 // Convert to kilometers
        let baseFare = 5.0 // Example base fare
        let perKmFare = 2.0 // Example fare per kilometer

        fare = baseFare + (distance * perKmFare)
    }

    func requestRide() {
        guard let pickup = pickupLocation, let dropoff = dropoffLocation else {
            errorMessage = "Please set both pickup and dropoff locations."
            return
        }

        let ride = Ride(id: UUID().uuidString,
                        userId: authService.user?.id ?? "", // Make sure you are passing userId
                        pickupLocation: pickup,
                        dropoffLocation: dropoff,
                        timestamp: timestamp,
                        fare: fare,
                        driverId: selectedDriver?.id ?? "") // Ensure the correct order and parameter names

        rideService.requestRide(ride: ride)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { success in
                if success {
                    // Handle successful ride request
                    self.rideHistory.append(ride)
                }
            })
            .store(in: &cancellables)
    }

    
    // Fetch ride history for the logged-in user
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
                         userId: "", // If you have user ID, set it here
                         pickupLocation: CLLocationCoordinate2D(latitude: history.pickupLocation.latitude, longitude: history.pickupLocation.longitude),
                         dropoffLocation: CLLocationCoordinate2D(latitude: history.dropOffLocation.latitude, longitude: history.dropOffLocation.longitude),
                         timestamp: history.timestamp,
                         fare: history.fare,
                         driverId: history.driver.id) // Make sure driver exists
                }
            })
            .store(in: &cancellables)
    }

//    // Load available drivers
//    func loadAvailableDrivers(completion: @escaping ([Driver]) -> Void) {
//        rideService.fetchAvailableDrivers()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    self.errorMessage = error.localizedDescription
//                }
//            }, receiveValue: { drivers in
//                completion(drivers)
//            })
//            .store(in: &cancellables)
//    }
    
    // Load available drivers (already present in your code)
    func loadAvailableDrivers(completion: @escaping ([Driver]) -> Void) {
        rideService.fetchAvailableDrivers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // Handle error or success
            }, receiveValue: { drivers in
                self.availableDrivers = drivers // Store fetched drivers
                completion(drivers)
            })
            .store(in: &cancellables)
    }
}

