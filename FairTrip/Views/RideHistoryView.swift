////
////  RideHistoryView.swift
////  FairTrip
////
////  Created by Anmol Ranjan on 20/10/24.
////
//
import SwiftUI
import Combine

struct RideHistoryView: View {
    @StateObject private var viewModel = RideHistoryViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.rideHistories) { ride in
                NavigationLink(destination: RideDetailView(ride: ride)) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Pickup: \(ride.pickupLocation.latitude), \(ride.pickupLocation.longitude)")
                            Text("Dropoff: \(ride.dropOffLocation.latitude), \(ride.dropOffLocation.longitude)")
                            Text("Driver: \(ride.driver.name)")
                            Text("Fare: ₹\(ride.fare, specifier: "%.2f")")
                            Text("Status: \(ride.rideStatus.rawValue.capitalized)")
                                .font(.subheadline)
                                .foregroundColor(ride.rideStatus == .completed ? .green : .orange)
                        }
                        Spacer()
                        Text(viewModel.dateFormatter.string(from: ride.timestamp))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Ride History")
            .onAppear {
                viewModel.fetchRideHistory(for: "user_id_example") // Replace with actual user ID
            }
        }
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
