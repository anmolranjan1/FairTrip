//
//  PaymentView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI

struct PaymentView: View {
    @ObservedObject var viewModel: RideViewModel
    var selectedDriver: Driver?
    @Environment(\.presentationMode) var presentationMode // For dismissing the view

    var body: some View {
        VStack {
            Text("Payment")
                .font(.title)
                .padding()

            if let driver = selectedDriver {
                Text("Driver: \(driver.name)")
                    .font(.headline)
                Text("Vehicle: \(driver.vehicleModel)")
                    .font(.subheadline)
                Text("License Plate: \(driver.licensePlate)")
                    .font(.subheadline)
                if let rating = driver.rating {
                    Text("Rating: \(rating, specifier: "%.1f")")
                        .font(.subheadline)
                }
            }

            Text("Total Fare: \(viewModel.fare, specifier: "%.2f")")
                .font(.title2)
                .padding()

            Button(action: {
                confirmPayment()
            }) {
                Text("Confirm Payment")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
    }

    private func confirmPayment() {
        // Here you should handle the payment processing
        
        // Assuming the ride data is already set in the ViewModel
        let ride = Ride(
            id: UUID().uuidString,
            userId: "user_id_example", // Replace with actual user ID
            pickupLocation: viewModel.pickupLocation!,
            dropoffLocation: viewModel.dropoffLocation!,
            timestamp: Date(),
            fare: viewModel.fare,
            driverId: selectedDriver?.id ?? "driver_id_example" // Replace with actual driver ID
        )
        
        // Save the ride to Firebase
        viewModel.saveRide(ride) { success in
            if success {
                // Navigate back to home screen
                presentationMode.wrappedValue.dismiss()
            } else {
                // Handle error (show alert, etc.)
                print("Error saving ride to Firebase.")
            }
        }
    }
}



