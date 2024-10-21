import SwiftUI

struct RideRequestView: View {
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
                    viewModel.calculateFare() // Recalculate fare when selecting a driver
                }
            }
            
            Text("Fare: \(viewModel.fare, specifier: "%.2f")")
                            .font(.title2)
                            .padding()
            
            if !showSuccessMessage {
                // Pay Now button to navigate to payment
                Button(action: {
                    confirmPayment()
                }) {
                    Text("Pay Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedDriver == nil) // Disable if no driver is selected
            } else {
                Button(action: {
                    // Payment confirmation or further action
                }) {
                    Text("Paid")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedDriver == nil) // Disable if no driver is selected
            }

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
            viewModel.calculateFare() // Recalculate fare when the view appears
        }
    }

    private func confirmPayment() {
        guard let pickupLocation = viewModel.pickupLocation,
              let dropoffLocation = viewModel.dropoffLocation,
              let selectedDriver = selectedDriver else {
            print("Invalid ride details.")
            return
        }

        let ride = Ride(
            id: UUID().uuidString, // Use a UUID for the ride ID
            userId: "user_id_example", // Replace with actual user ID
            pickupLocation: pickupLocation,
            dropoffLocation: dropoffLocation,
            timestamp: Date(),
            fare: viewModel.fare,
            driver: selectedDriver // This is correct as `Driver` is passed
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
