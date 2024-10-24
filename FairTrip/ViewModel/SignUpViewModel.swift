//
//  SignUpViewModel.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var name: String = "" // Adding name to the view model
    @Published var email: String = ""
    @Published var phone: String = "" // Change to String to accommodate leading zeros
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isSignedUp: Bool = false // Add this property to track sign-up state
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthService
    private var isSignedUpBinding: Binding<Bool> // Add a Binding for isSignedUp
    
    init(authService: AuthService, isSignedUp: Binding<Bool>) {
        self.authService = authService
        self.isSignedUpBinding = isSignedUp // Set the Binding
    }

    // Perform signup action
    func signUp() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !name.isEmpty, !phone.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        
        print("Attempting to sign up user: \(email)")
        
        // Pass the name and phone number to the signup method
        authService.signUp(email: email, password: password, name: name, phone: phone)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                        print("Sign up failed: \(error)")
                }
            }, receiveValue: { user in
                self.isSignedUp = true // Update isSignedUp state
                self.isSignedUpBinding.wrappedValue = true // Update binding state
                self.authService.user = user // Set the newly created user
                print("User signed up successfully: \(user)")
            })
            .store(in: &cancellables)
    }
}
