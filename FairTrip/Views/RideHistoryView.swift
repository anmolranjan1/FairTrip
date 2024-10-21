////
////  RideHistoryView.swift
////  FairTrip
////
////  Created by Anmol Ranjan on 20/10/24.
////
//
import SwiftUI

struct RideHistoryView: View {
    @ObservedObject var viewModel: RideHistoryViewModel
    var userId: String // Assume userId is passed to this view

    var body: some View {
        Text("Ride Details")
            .font(.largeTitle)
            .padding()
        List(viewModel.rideHistories) { rideHistory in
            VStack(alignment: .leading) {
                Text("Pickup: \(rideHistory.pickupLocation.latitude), \(rideHistory.pickupLocation.longitude)")
                Text("Dropoff: \(rideHistory.dropOffLocation.latitude), \(rideHistory.dropOffLocation.longitude)")
                Text("Fare: \(rideHistory.fare, specifier: "%.2f")")
                Text("Driver: \(rideHistory.driver.name)")
                Text("Status: \(rideHistory.rideStatus.rawValue.capitalized)")
                Text("Timestamp: \(viewModel.dateFormatter.string(from: rideHistory.timestamp))")
            }
        }
        .onAppear {
            print("RideHistoryView appeared. Fetching ride history for user: \(userId)") // Debugging line
            viewModel.refreshRideHistory(for: userId) // Refresh ride history when the view appears
        }
        .navigationTitle("Ride History")
    }
}


struct RideDetailView: View {
    var ride: RideHistory
    
    var body: some View {
        VStack {
            Text("Ride Details")
                .font(.largeTitle)
                .padding()
            Text("Pickup Location: \(ride.pickupLocation.latitude), \(ride.pickupLocation.longitude)")
            Text("Drop-off Location: \(ride.dropOffLocation.latitude), \(ride.dropOffLocation.longitude)")
            Text("Driver: \(ride.driver.name) (\(ride.driver.vehicleModel))")
            Text("Fare: ₹\(ride.fare, specifier: "%.2f")")
            Text("Status: \(ride.rideStatus.rawValue.capitalized)")
            Text("Date: \(ride.timestamp.formatted())")
                .padding(.top)
            Spacer()
        }
        .padding()
        .navigationTitle("Ride Detail")
    }
}
