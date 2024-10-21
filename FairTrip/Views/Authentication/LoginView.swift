import SwiftUI

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel // Declare it as a StateObject
    @Binding var isLoggedIn: Bool

    init(isLoggedIn: Binding<Bool>, authService: AuthService) {
        self._isLoggedIn = isLoggedIn
        self._viewModel = StateObject(wrappedValue: LoginViewModel(authService: authService, isLoggedIn: isLoggedIn))
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.textColor)

                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()

                Button(action: {
                    viewModel.login()
                }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor)
                        .foregroundColor(.backgroundColor)
                        .cornerRadius(10)
                }
                .padding()

                NavigationLink(destination: SignUpView(isSignedUp: .constant(false), authService: viewModel.getAuthService())) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.accentColor)
                }
                .padding()

                NavigationLink(destination: HomeView(), isActive: $viewModel.isLoggedIn) {
                    EmptyView()
                }

                Spacer()
            }
            .padding()
            .background(Color.backgroundColor)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Preview for testing
struct LoginView_Previews: PreviewProvider {
    @State static var isLoggedIn = false

    static var previews: some View {
        LoginView(isLoggedIn: $isLoggedIn, authService: AuthService())
            .preferredColorScheme(.light)
        LoginView(isLoggedIn: $isLoggedIn, authService: AuthService())
            .preferredColorScheme(.dark)
    }
}
