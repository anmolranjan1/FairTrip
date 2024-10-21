//
//  SignUpView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel: SignUpViewModel // Declare it as a StateObject

    // Initialize with AuthService and the binding
    init(isSignedUp: Binding<Bool>, authService: AuthService) {
        self._viewModel = StateObject(wrappedValue: SignUpViewModel(authService: authService, isSignedUp: isSignedUp))
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Create Account")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.textColor)

                TextField("Name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(height: 30)

                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.secondaryColor) // Updated to use custom secondary color
                    .autocapitalization(.none)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.secondaryColor) // Updated to use custom secondary color
                    .autocapitalization(.none)

                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()

                Button(action: {
                    viewModel.signUp() // Call the sign-up function
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor) // Updated to use custom primary color
                        .foregroundColor(.backgroundColor) // Updated to use custom background color
                        .cornerRadius(10)
                }
                .padding()

                NavigationLink(destination: LoginView(isLoggedIn: .constant(false), authService: AuthService())) {
                    Text("Already have an account? Log In")
                        .foregroundColor(.accentColor) // Updated to use custom accent color
                }
                .padding()

                Spacer()
            }
            .padding()
//            .navigationTitle("Sign Up")
            .background(Color.backgroundColor) // Set the background color
        }
    }
}

// Preview for testing
struct SignUpView_Previews: PreviewProvider {
    @State static var isSignedUp = false

    static var previews: some View {
        // Provide a mock AuthService instance
        SignUpView(isSignedUp: $isSignedUp, authService: AuthService())
            .preferredColorScheme(.light) // Preview in light mode
        SignUpView(isSignedUp: $isSignedUp, authService: AuthService())
            .preferredColorScheme(.dark) // Preview in dark mode
    }
}
