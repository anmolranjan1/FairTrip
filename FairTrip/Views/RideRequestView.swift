//
//  RideRequestView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI
import MapKit

struct RideRequestView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: RideViewModel
    var pickupLocation: String
    var dropoffLocation: String
    var timestamp: Date

    @State private var selectedDriver: Driver?
    @State private var distance: String = ""
    @State private var estimatedTime: String = ""
    
    var body: some View {
        VStack {
            Text("Ride Request Confirmation")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.primaryColor) // Custom primary color

            Text("Pickup Location: \(pickupLocation)")
                .padding()
                .foregroundColor(.textColor) // Custom text color

            Text("Dropoff Location: \(dropoffLocation)")
                .padding()
                .foregroundColor(.textColor) // Custom text color

            Text("Requested Time: \(timestamp.formatted())")
                .padding()
                .foregroundColor(.textColor) // Custom text color

            if let driver = selectedDriver {
                Text("Selected Driver: \(driver.name)")
                    .foregroundColor(.textColor) // Custom text color
                Text("Car Model: \(driver.vehicleModel)")
                    .foregroundColor(.textColor) // Custom text color
                Text("License Plate: \(driver.licensePlate)")
                    .foregroundColor(.textColor) // Custom text color
            } else {
                Text("No driver selected yet.")
                    .foregroundColor(.textColor) // Custom text color
            }

            Spacer()

            Button(action: {
                // Call method to fetch distance and time estimates here
                fetchRideDetails()
            }) {
                Text("Get Ride Details")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryColor) // Custom primary color
                    .foregroundColor(.backgroundColor) // Custom background color
                    .cornerRadius(10)
            }
            .padding()

            if !distance.isEmpty {
                Text("Distance: \(distance)")
                    .foregroundColor(.textColor) // Custom text color
                Text("Estimated Time: \(estimatedTime)")
                    .foregroundColor(.textColor) // Custom text color
            }

            Button(action: {
                // Action for payment
            }) {
                Text("Pay Now")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green) // Or a custom color
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .onAppear {
            // Load drivers or select a default one
            loadDrivers()
        }
        .background(Color.backgroundColor) // Set the background color
    }

    private func loadDrivers() {
        viewModel.loadAvailableDrivers { drivers in
            if let firstDriver = drivers.first {
                selectedDriver = firstDriver
            }
        }
    }

    private func fetchRideDetails() {
        // Simulating fetching distance and time
        distance = "10 km" // Replace with actual calculation
        estimatedTime = "20 minutes" // Replace with actual calculation
    }
}

#Preview {
    RideRequestView(viewModel: RideViewModel(rideService: RideService(), authService: AuthService()), pickupLocation: "Location A", dropoffLocation: "Location B", timestamp: Date())
}
