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
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthService
    private var isLoggedIn: Binding<Bool> // Add a Binding for isLoggedIn
    
    init(authService: AuthService, isLoggedIn: Binding<Bool>) {
        self.authService = authService
        self.isLoggedIn = isLoggedIn // Set the Binding
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
                self.isLoggedIn.wrappedValue = true // Update isLoggedIn state
                self.authService.user = user // Set the logged-in user
            })
            .store(in: &cancellables)
    }
    
    // Public method to get authService
    func getAuthService() -> AuthService {
        return authService
    }
}
