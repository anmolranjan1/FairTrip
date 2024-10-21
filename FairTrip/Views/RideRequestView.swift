//
//  RideRequestView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI

struct RideRequestView: View {
    
    //    @ObservedObject var viewModel: RideViewModel
    //    var selectedDriver: Driver?
    //    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    //
    //    @State private var showSuccessMessage: Bool = false // State for success message
    //    @State private var successMessage: String = "" // Store the success message
    @ObservedObject var viewModel: RideViewModel
    @State private var selectedDriver: Driver?
    @State private var showSuccessMessage: Bool = false // State for success message

    var body: some View {
        VStack {
            Text("Available Drivers")
                .font(.title)
                .padding()

            List(viewModel.availableDrivers) { driver in
                VStack(alignment: .leading) {
                    Text(driver.name)
                        .font(.headline)
                    Text(driver.vehicleModel)
                        .font(.subheadline)
                    Text(driver.licensePlate)
                        .font(.subheadline)
                    if let rating = driver.rating {
                        Text("Rating: \(rating, specifier: "%.1f")")
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(selectedDriver?.id == driver.id ? Color.gray.opacity(0.2) : Color.clear) // Highlight selected driver
                .onTapGesture {
                    selectedDriver = driver // Update selected driver
                }
            }

            // Pay Now button to navigate to payment
            Button(action: {
                confirmPayment()
            }) {
                Text("Pay Now \(viewModel.fare, specifier: "%.2f")")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(selectedDriver == nil) // Disable if no driver is selected
            
            // Show success message
            if showSuccessMessage {
                Text("Payment successful! Go back to homepage...")
                    .foregroundColor(.green)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Ride Request")
        .onAppear {
            viewModel.fetchAvailableDrivers() // Fetch drivers when the view appears
        }
    }

    private func confirmPayment() {
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
                // Fetch updated ride history after successful payment
                self.viewModel.fetchRideHistory() // Update ride history
                
                // Show success message
                showSuccessMessage = true
                
                // Navigate back to home screen after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Dismiss to go back to home view
                    if let navigationController = UIApplication.shared.windows.first?.rootViewController as? UINavigationController {
                        navigationController.popToRootViewController(animated: true)
                    }
                }
            } else {
                print("Error saving ride to Firebase.")
                showSuccessMessage = false // Optionally hide success message on error
            }
        }
    }

}
