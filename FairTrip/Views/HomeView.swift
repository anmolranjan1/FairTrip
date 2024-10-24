import SwiftUI
import CoreLocation
import MapKit

struct HomeView: View {
    private let rideService = RideService()
    private let authService = AuthService()
    
    @StateObject private var viewModel = RideViewModel(rideService: RideService(), authService: AuthService())
    @State private var showRideHistory = false
    @State private var showProfile = false
    @State private var pickupLocation: String = ""
    @State private var dropoffLocation: String = ""
    @State private var timestamp: Date = Date()
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchCompleter = LocationSearchCompleter()
    @State private var navigateToRideRequest = false
    
    // Assuming you have a userID available, either from authService or elsewhere
    private var userId: String {
        authService.user?.id ?? "unknown" // Replace with your actual logic
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Request a Ride")
                        .font(.title)
                        .padding()
                        .foregroundColor(.textColor)
                    
                    Spacer()
                    
                    // Profile Button
                    Button(action: {
                        showProfile.toggle()
                    }) {
                        Image(systemName: "person.circle") // Icon for Profile
                            .font(.title)
                            .foregroundColor(.textColor)
                            .padding()
                    }
                    
                    // Ride History Button
                    Button(action: {
                        showRideHistory.toggle()
                    }) {
                        Image(systemName: "clock.fill") // Icon for Ride History
                            .font(.title)
                            .foregroundColor(.textColor)
                            .padding()
                    }
                }
                
                Spacer().frame(height: 20)

                HStack(spacing: 0) {
                    Text("Pickup Location: ")
                        .foregroundColor(Color(.white))
                    
                    Spacer()
                    
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
                    if let currentLocation = locationManager.currentLocation {
                        viewModel.pickupLocation = currentLocation
                    }
                    viewModel.dropoffLocation = CLLocationCoordinate2D(latitude: 40.748817, longitude: -73.985428)
                    
                    viewModel.timestamp = timestamp
                    viewModel.calculateFare() // Calculate fare before requesting the ride
                    viewModel.requestRide()  // No need to pass arguments
                    
                    navigateToRideRequest = true
                }) {
                    Text("Order Now")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor) // Use the custom primary color
                        .foregroundColor(.backgroundColor) // Use the custom background color
                        .cornerRadius(10)
                }
                .padding()
                
                NavigationLink(destination: RideRequestView(viewModel: viewModel), isActive: $navigateToRideRequest) {
                    EmptyView() // Invisible navigation link
                }
                
                Button(action: {
                    rideService.addDummyDriver()
                    rideService.addDummyRide(userId: userId) // Pass userId to addDummyRide
                }) {
                    Text("Add Dummy Data")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer().frame(height: 20)
            }
            .padding()
            .sheet(isPresented: $showProfile) {
                ProfileView() // Assuming you have a ProfileView to show
            }
            .sheet(isPresented: $showRideHistory) {
                RideHistoryView(userId: userId, rideService: rideService, authService: authService) // Pass the userId
            }
            .background(Color.backgroundColor)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
}
