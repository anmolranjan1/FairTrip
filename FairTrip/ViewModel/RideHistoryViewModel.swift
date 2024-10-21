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
        rideService.fetchRideHistory(for: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching ride history: \(error.localizedDescription)")
                }
            }, receiveValue: { rideHistories in
                self.rideHistories = rideHistories
            })
            .store(in: &cancellables)
    }
    
    // Call this function to refresh ride history whenever needed
    func refreshRideHistory(for userId: String) {
        fetchRideHistory(for: userId)
    }
}

