import SwiftUI

struct RideHistoryView: View {
    @StateObject private var viewModel: RideHistoryViewModel
    var userId: String // Assume userId is passed to this view

    init(userId: String, rideService: RideService, authService: AuthService) {
        self.userId = userId
        self._viewModel = StateObject(wrappedValue: RideHistoryViewModel(rideService: rideService, authService: authService))
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Ride History")
                    .font(.largeTitle)
                    .padding()

                // Display error message if available
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // Display ride history manually using VStack
                ForEach(viewModel.rideHistories, id: \.id) { rideHistory in
                    VStack(alignment: .leading) {
                        Text("Pickup: \(rideHistory.pickupLocation.latitude), \(rideHistory.pickupLocation.longitude)")
                        Text("Dropoff: \(rideHistory.dropoffLocation.latitude), \(rideHistory.dropoffLocation.longitude)")
                        Text("Fare: \(rideHistory.fare, specifier: "%.2f")")
                        Text("Driver: \(rideHistory.driver?.name ?? "Unknown")")
                        Text("Timestamp: \(rideHistory.timestamp, formatter: dateFormatter)")
                            .padding(.bottom)

                        Divider() // Optional divider between rides
                    }
                    .padding()
                    .background(Color(.systemGray6)) // Optional background color for each ride
                    .cornerRadius(10) // Optional corner radius
                }
            }
            .padding()
            .onAppear {
                // Fetch rides every time the view appears
                viewModel.refreshRideHistory(for: userId)
            }
        }
        .navigationTitle("Ride History")
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
