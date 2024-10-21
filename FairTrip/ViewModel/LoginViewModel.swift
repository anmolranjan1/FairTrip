//
//  LoginViewModel.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false // Add this property
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthService
    private var isLoggedInBinding: Binding<Bool> // Change the name for clarity

    init(authService: AuthService, isLoggedIn: Binding<Bool>) {
        self.authService = authService
        self.isLoggedInBinding = isLoggedIn
    }

    // Perform login action
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password cannot be empty."
            return
        }
        
        authService.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { user in
                self.isLoggedInBinding.wrappedValue = true // Update isLoggedIn state
                self.authService.user = user // Set the logged-in user
                self.isLoggedIn = true // Trigger navigation
            })
            .store(in: &cancellables)
    }

    func getAuthService() -> AuthService {
        return authService
    }
}
