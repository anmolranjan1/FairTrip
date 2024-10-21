//
//  RideHistoryView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI

struct RideHistoryView: View {
    @StateObject private var viewModel: RideViewModel
    var userId: String // Assume userId is passed to this view

    init(userId: String, rideService: RideService, authService: AuthService) {
        self.userId = userId
        self._viewModel = StateObject(wrappedValue: RideViewModel(rideService: rideService, authService: authService))
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
                ForEach(viewModel.rideHistory, id: \.id) { rideHistory in
                    VStack(alignment: .leading) {
                        Text("Pickup: \(rideHistory.pickupLocation.latitude), \(rideHistory.pickupLocation.longitude)")
                        Text("Dropoff: \(rideHistory.dropoffLocation.latitude), \(rideHistory.dropoffLocation.longitude)")
                        Text("Fare: \(rideHistory.fare, specifier: "%.2f")")
                        Text("Driver: \(rideHistory.driver?.name ?? "Unknown")") // Assuming Driver has a 'name' property
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
                viewModel.fetchRideHistory() // Fetch rides on appear
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
