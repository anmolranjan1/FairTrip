//
//  RideHistoryViewModel.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import Foundation
import Combine
import Firebase

class RideHistoryViewModel: ObservableObject {
    @Published var rideHistories: [Ride] = []
    private var cancellables = Set<AnyCancellable>()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    // Fetch ride history for a specific user
    func refreshRideHistory(for userId: String) {
        let db = Firestore.firestore()
        
        db.collection("rides").whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching ride histories: \(error)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                
                // Ensure that the ride data is correctly decoded into Ride objects
                self?.rideHistories = documents.compactMap { doc in
                    try? doc.data(as: Ride.self)
                }
            }
    }
}
