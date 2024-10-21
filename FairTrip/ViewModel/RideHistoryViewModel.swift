import Foundation
import Combine
import Firebase

class RideHistoryViewModel: ObservableObject {
    @Published var rideHistories: [Ride] = []
    @Published var errorMessage: String? // Add error message property
    private var cancellables = Set<AnyCancellable>()
    
    private let rideService: RideService // Store the ride service
    private let authService: AuthService // Store the auth service

    // Initializer to accept services
    init(rideService: RideService, authService: AuthService) {
        self.rideService = rideService
        self.authService = authService
    }

    // Fetch ride history for a specific user
    func refreshRideHistory(for userId: String) {
        let db = Firestore.firestore()
        
        db.collection("rides").whereField("userId", isEqualTo: userId)
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching ride histories: \(error)")
                    self?.errorMessage = "Failed to fetch ride histories." // Set error message
                    return
                }
                guard let documents = snapshot?.documents else {
                    self?.errorMessage = "No rides found."
                    return
                }
                
                // Ensure that the ride data is correctly decoded into Ride objects
                self?.rideHistories = documents.compactMap { doc in
                    try? doc.data(as: Ride.self)
                }
                
                // Optionally reset error message after successful fetch
                self?.errorMessage = nil
            }
    }
}
