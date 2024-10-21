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
    
    func fetchRideHistory(for userId: String) {
        rideService.fetchRideHistory(for: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Failed to fetch ride history: \(error)")
                }
            }, receiveValue: { [weak self] rideHistories in
                self?.rideHistories = rideHistories
            })
            .store(in: &cancellables)
    }
}
