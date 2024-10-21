# FairTrip

## Project Overview
FairTrip is a modern ride-hailing application designed for iOS, utilizing SwiftUI for a seamless user interface. The app connects users with nearby drivers, streamlining the process of requesting, tracking, and managing rides. Leveraging Firebase for backend services ensures efficient real-time interactions and secure user authentication.

## Features
- **User Registration and Login**: Users can create an account and log in using Firebase Authentication with email and password.
- **Driver Management**: Admins can add and manage drivers, including their details and locations.
- **Ride Requests**: Users can request rides, specifying pickup and dropoff locations.
- **Ride Tracking**: Real-time tracking of rides with driver location updates.
- **Ride History**: Users can view their past rides and details such as fare and driver information.
- **Responsive UI**: Built using SwiftUI for a smooth and intuitive user experience.
- **Add Dummy Data**: An "Add Dummy Data" button is included on the home page, allowing you to populate the Firebase Firestore database with sample data for testing purposes.

## Technologies Used
- **Swift & SwiftUI**: Chosen for building a responsive and intuitive iOS application, ensuring a smooth user experience.
- **Firebase**: Provides real-time database capabilities and user authentication, allowing for seamless data management and security.
- **CoreLocation**: Used for accurate location tracking of users and drivers during ride requests.
- **Combine**: Utilized for handling asynchronous data streams, improving app responsiveness.

## Setup Instructions
1. Download the **GoogleService-Info.plist** file from your Firebase console.
2. Add the **GoogleService-Info.plist** file to the **Resources** folder of your Xcode project.
3. Ensure that Firebase is properly configured in your app's `AppDelegate` or `SceneDelegate`.

## Usage
- Launch the app on your device or simulator.
- Sign up or log in to your account using email and password.
- View available drivers and request a ride by specifying pickup and dropoff locations.
- Track your ride in real-time and check your ride history.
- Use the "Add Dummy Data" button on the home page to populate the database with sample driver and ride data for testing.

## Future Improvements
- Implementing push notifications for ride updates.
- Adding a rating system for drivers and passengers.
- Integrating payment processing for seamless transactions.

## Contribution
Contributions are welcome! If you'd like to contribute to the project, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.
