//
//  ContentView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI

struct ContentView: View {
//    @Binding var isLoggedIn: Bool
    @State private var isLoggedIn = false
    private var authService = AuthService()

    var body: some View {
            if isLoggedIn {
                // Show the Home view when the user is logged in
                HomeView() // Replace with your actual home view
            } else {
                // Show the Login view when the user is not logged in
                LoginView(isLoggedIn: $isLoggedIn, authService: authService)
            }
    }
}

#Preview {
    ContentView()
}
