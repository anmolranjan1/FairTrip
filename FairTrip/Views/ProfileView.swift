//  ProfileView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI
import FirebaseStorage

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text("Name:")
                    TextField("Enter your name", text: Binding(
                        get: { viewModel.user?.name ?? "User" },
                        set: { viewModel.user?.name = $0 }
                    ))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.secondaryColor) // Custom secondary color
                }

                HStack {
                    Text("Email:")
                    TextField("Enter your email", text: Binding(
                        get: { viewModel.user?.email ?? "user@gmail.com" },
                        set: { viewModel.user?.email = $0 }
                    ))
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.secondaryColor) // Custom secondary color
                }

                HStack {
                    Text("Phone:")
                    TextField("Enter your phone number", text: Binding(
                        get: { viewModel.user?.phoneNumber ?? "" },
                        set: { viewModel.user?.phoneNumber = $0 }
                    ))
                    .keyboardType(.phonePad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.secondaryColor) // Custom secondary color
                }

                HStack {
                    Text("Profile Picture:")
                    Spacer()
                    if let imageUrl = viewModel.user?.profilePictureURL,
                       let image = viewModel.loadImage(from: imageUrl) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                }
                .onTapGesture {
                    showingImagePicker = true
                }

                Button(action: {
                    viewModel.updateProfile()
                }) {
                    Text("Update Profile")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryColor) // Custom primary color
                        .foregroundColor(.backgroundColor) // Custom background color
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchProfile()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage, onImagePicked: {
                    if let image = inputImage {
                        viewModel.uploadProfileImage(image)
                    }
                })
            }
            .background(Color.backgroundColor) // Set the background color
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImagePicked: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.onImagePicked()
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// Preview for testing
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(MockProfileViewModel()) // Provide a mock view model for preview
    }
}

// Mock ViewModel for Preview
class MockProfileViewModel: ObservableObject {
    @Published var user: User?

    init() {
        self.user = User(id: "1", name: "John Doe", email: "john@example.com", phoneNumber: "1234567890", profilePictureURL: nil)
    }
}
