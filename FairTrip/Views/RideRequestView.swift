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

//            // Display available drivers
//            if let drivers = viewModel.availableDrivers {
//                List(drivers) { driver in
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Driver: \(driver.name)")
//                            Text("Vehicle: \(driver.vehicleModel.model)")
//                            Text("Rating: \(driver.rating, specifier: "%.1f")")
//                        }
//                        Spacer()
//                        Button(action: {
//                            selectedDriver = driver
//                            viewModel.selectedDriver = driver
//                        }) {
//                            Text(selectedDriver?.id == driver.id ? "Selected" : "Select")
//                                .padding(10)
//                                .background(selectedDriver?.id == driver.id ? Color.green : Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(8)
//                        }
//                    }
//                }
//            } else {
//                Text("Loading drivers...")
//                    .onAppear {
//                        viewModel.loadAvailableDrivers { drivers in
//                            viewModel.availableDrivers = drivers
//                        }
//                    }
//            }

            // Show estimated fare
            HStack {
                Text("Estimated Fare: \(viewModel.fare, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                Spacer()
            }

            // Pay Now button to navigate to payment
            Button(action: {
                showPaymentView = true
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
            .sheet(isPresented: $showPaymentView) {
                PaymentView(viewModel: viewModel) // Navigate to payment screen
            }
        }
        .padding()
        .navigationTitle("Ride Request")
    }
}




//#Preview {
//    RideRequestView(viewModel: RideViewModel(rideService: RideService(), authService: AuthService()), pickupLocation: "Location A", dropoffLocation: "Location B", timestamp: Date())
//}
