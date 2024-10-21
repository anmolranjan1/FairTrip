//
//  HomeView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct HomeView: View {
    private let rideService = RideService()
    private let authService = AuthService()
    
    @StateObject private var viewModel = RideViewModel(rideService: RideService(), authService: AuthService())
    @StateObject private var rideHistoryViewModel = RideHistoryViewModel()
    @State private var showRideHistory = false
    @State private var showProfile = false
    @State private var pickupLocation: String = ""
    @State private var dropoffLocation: String = ""
    @State private var timestamp: Date = Date()
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchCompleter = LocationSearchCompleter()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Request a Ride")
                        .font(.title)
                        .padding()
                        .foregroundColor(.textColor) // Use the custom text color
                    
                    Spacer()
                    
                    Menu {
                        Button(action: {
                            showProfile.toggle()
                        }) {
                            Text("Profile")
                        }
                        Button(action: {
                            showRideHistory.toggle()
                        }) {
                            Text("Ride History")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle") // Icon for the menu
                            .font(.title)
                            .foregroundColor(.textColor)
                            .padding()
                    }
                }
                
                Spacer().frame(height: 20)

//                TextField("From Where to be Picked Up", text: $pickupLocation)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding(10)
//                .background(Color.secondaryColor) // Use the custom secondary color
                
                HStack(spacing: 0) {
                    Text("Pickup Location: ")
                        .font(.headline)
                    
                    Text(locationManager.currentAddress ?? "Fetching location...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .onAppear {
                            locationManager.requestLocation()
                        }
                }
                .padding(10)
                .background(Color.secondaryColor)

//                TextField("Where You Want to Go", text: $dropoffLocation)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding(10)
//                    .background(Color.secondaryColor) // Use the custom secondary color
                
                // Dropoff Location with Suggestions
                TextField("Where You Want to Go", text: $dropoffLocation, onEditingChanged: { isEditing in
                    if isEditing && !dropoffLocation.isEmpty {
                        searchCompleter.searchQuery = dropoffLocation
                    }
                })
                .onChange(of: dropoffLocation) { newValue in
                    searchCompleter.searchQuery = newValue
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(10)
                .background(Color.secondaryColor) // Use the custom secondary color

                // Display suggestions from MKLocalSearchCompleter
                List(searchCompleter.suggestions, id: \.title) { suggestion in
                    Button(action: {
                        dropoffLocation = suggestion.title
                        searchCompleter.searchQuery = ""
                    }) {
                        VStack(alignment: .leading) {
                            Text(suggestion.title)
                                .font(.system(size: 14))
                            if !suggestion.subtitle.isEmpty {
                                Text(suggestion.subtitle)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .frame(height: 150)

                DatePicker("Select Date and Time", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])
                    .padding()
                    .foregroundColor(.textColor) // Use the custom text color
                
                Spacer()

                Button(action: {
                    // viewModel.pickupLocation = CLLocationCoordinate2D() // Set this based on user input
                    // viewModel.dropoffLocation = CLLocationCoordinate2D() // Set this based on user input
                    if let currentLocation = locationManager.currentLocation {
                        viewModel.pickupLocation = currentLocation
                    }
                    viewModel.dropoffLocation = CLLocationCoordinate2D(latitude: 40.748817, longitude: -73.985428)
                    
                    viewModel.timestamp = timestamp
                    viewModel.calculateFare() // Calculate fare before requesting the ride
                    viewModel.requestRide()  // No need to pass arguments
                }) {
                    Text("Order Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor) // Use the custom primary color
                        .foregroundColor(.backgroundColor) // Use the custom background color
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    rideService.addDummyDriver()
                    rideService.addDummyRide()
//                    rideService.addDummyRideHistory()
                }) {
                    Text("Add Dummy Data")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

//                NavigationLink(destination: RideHistoryView(viewModel: rideHistoryViewModel)) {
//                    Text("Ride History")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.orange)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding()

                Spacer().frame(height: 20)
            }
            .padding()
//            .navigationTitle("Home")
            .sheet(isPresented: $showProfile) {
                ProfileView() // Assuming you have a ProfileView to show
            }
            .sheet(isPresented: $showRideHistory) {
                RideHistoryView()
            }
            .background(Color.backgroundColor)
        }
    }
}

#Preview {
    HomeView()
}
