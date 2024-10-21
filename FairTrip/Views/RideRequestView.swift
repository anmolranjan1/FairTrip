//
//  RideRequestView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI

struct RideRequestView: View {
    @ObservedObject var viewModel: RideViewModel
    @State private var selectedDriver: Driver?
    @State private var showPaymentView = false

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
                showPaymentView = true
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
            .sheet(isPresented: $showPaymentView) {
                PaymentView(viewModel: viewModel, selectedDriver: selectedDriver) // Pass selected driver to payment view
            }
        }
        .padding()
        .navigationTitle("Ride Request")
        .onAppear {
            viewModel.fetchAvailableDrivers() // Fetch drivers when the view appears
        }
    }
}





//#Preview {
//    RideRequestView(viewModel: RideViewModel(rideService: RideService(), authService: AuthService()), pickupLocation: "Location A", dropoffLocation: "Location B", timestamp: Date())
//}
