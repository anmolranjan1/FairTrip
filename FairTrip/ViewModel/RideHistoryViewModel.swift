//
//  RideHistoryViewModel.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import Combine

class RideHistoryViewModel: ObservableObject {
    @Published var rideHistories: [RideHistory] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let rideService = RideService()
    
    // DateFormatter to display the timestamp in a readable format
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Function to fetch ride history for a specific user
    func fetchRideHistory(for userId: String) {
        print("Fetching ride history for user: \(userId)") // Debugging line
        rideService.fetchRideHistory(for: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Fetch completed successfully") // Debugging line
                case .failure(let error):
                    print("Error fetching ride history: \(error.localizedDescription)") // Debugging line
                }
            }, receiveValue: { rideHistories in
                print("Fetched ride histories: \(rideHistories)") // Debugging line
                self.rideHistories = rideHistories
            })
            .store(in: &cancellables)
    }
    
    // Call this function to refresh ride history whenever needed
    func refreshRideHistory(for userId: String) {
        fetchRideHistory(for: userId)
    }
}


