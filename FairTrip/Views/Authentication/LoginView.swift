import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel // Declare it as a StateObject
    @Binding var isLoggedIn: Bool

    // Initialize with AuthService and the binding
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
                    .foregroundColor(.textColor) // Use the custom text color

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
                        .background(Color.primaryColor) // Use the custom primary color
                        .foregroundColor(.backgroundColor) // Use the custom background color
                        .cornerRadius(10)
                }
                .padding()

                NavigationLink(destination: SignUpView(isSignedUp: .constant(false), authService: viewModel.getAuthService())) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.accentColor) // Use the custom accent color
                }
                .padding()

                NavigationLink(destination: HomeView()) {
                    EmptyView()
                }

                Spacer()
            }
            .padding()
//            .navigationTitle("Login")
            .background(Color.backgroundColor) // Set the background color
        }
    }
}

// Preview for testing
struct LoginView_Previews: PreviewProvider {
    @State static var isLoggedIn = false

    static var previews: some View {
        // Provide a mock AuthService instance
        LoginView(isLoggedIn: $isLoggedIn, authService: AuthService())
            .preferredColorScheme(.light) // Preview in light mode
        LoginView(isLoggedIn: $isLoggedIn, authService: AuthService())
            .preferredColorScheme(.dark) // Preview in dark mode
    }
}
