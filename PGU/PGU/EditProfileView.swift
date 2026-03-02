//
//  EditProfileView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/31/23.
//

import SwiftUI
import Firebase // Ensure Firebase is imported to use Firestore

struct EditProfileView: View {
    
    @State private var name: String = ""
    @State private var initialName: String = "" // To compare changes
    @State private var initialPhoneNumber: String = "" // To compare changes
    @State private var initialLocation: String = "" // To compare changes

//    @State private var username: String = ""
//    @State private var password: String = ""
//    @State private var membership: String = ""
    
    @State private var selectedLocation = "Location" // Default text

    
    @State private var phoneNumber: String = ""

    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage? = nil
    
    @State private var showAlert = false // For showing alerts
    @State private var alertMessage = "" // Message to display in the alert
    
    @State private var showDeleteConfirmation = false // State to control the confirmation alert display
    @State private var shouldShowLoginView = false

    

    let db = Firestore.firestore()

    
    var body: some View {
        
        Image("logo").resizable().scaledToFit().frame(width: 140, height: 50)
        
        Spacer()
        Spacer()
        Spacer()

        
        ScrollView {
            
            
            VStack{
                
                Text("EDIT PROFILE")
                    .padding()
                    .font(.title)
                    .fontWeight(.bold)
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill() // Ensures the image fills the frame
                        .frame(width: 150, height: 150) // Set the same size as your person.fill icon
                        .clipShape(Circle()) // Makes the image round
                        .overlay(Circle().stroke(Color(hex: "c7972b"), lineWidth: 2))
                    // additional styling if needed
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(30)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color(hex: "c7972b")))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(hex: "c7972b"), lineWidth: 2))
                    // styling for the default image
                }
                
                
                Text("Edit Photo")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        self.isImagePickerPresented = true
                    }
                
                Group {
                    HStack {
                        Text("Full Name")
                            .frame(width: 110, alignment: .leading) // Fixed width
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                        
                        
                    }
                    
                    //                HStack {
                    //                    Text("Email")
                    //                        .frame(width: 110, alignment: .leading) // Fixed width
                    //                        .fontWeight(.bold)
                    //
                    //                    TextField("Enter your email", text: $username)
                    //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                }
                    //
                    //                HStack {
                    //
                    //                    Text("Password")
                    //                        .frame(width: 110, alignment: .leading) // Fixed width
                    //                        .fontWeight(.bold)
                    //
                    //                    SecureField("Enter your password", text: $password)
                    //                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                }
                    
                    HStack {
                        
                        Text("Phone #")
                            .frame(width: 110, alignment: .leading) // Fixed width
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        TextField("Enter your number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.trailing)
                        
                    }
                    
                    HStack {
                        
                        Text("Select Location")
                            .frame(width: 110, alignment: .leading) // Fixed width
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        
                        ZStack {
                            // Mimic the background of SecureField
                            Rectangle()
                                .foregroundColor(Color(.systemBackground)) // Use your desired background color
                                .cornerRadius(5) // Match SecureField's corner radius
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.gray, lineWidth: 1) // Match SecureField's border
                                )
                                .padding(.vertical, 1) // Match SecureField's padding
                            
                            // Display the selected location
                            Text(selectedLocation)
                                .foregroundColor(.black) // Use your desired text color
                                .padding(.leading, 5) // Ensure text is not touching the edges
                        }
                        .frame(height: 36) // Match SecureField's height
                        
                        
                        Menu {
                            Button("Dodge City, KS", action: {
                                selectedLocation = "Dodge City, KS"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            Button("Limon, CO", action: { selectedLocation = "Limon, CO"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            Button("Goodland, KS", action: { selectedLocation = "Goodland, KS"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            Button("Canton, KS", action: { selectedLocation = "Canton, KS"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            Button("Grand Rapids, MI", action: { selectedLocation = "Grand Rapids, MI"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            Button("Lafayette, IN", action: { selectedLocation = "Lafayette, IN"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            Button("South Bend, IN", action: { selectedLocation = "South Bend, IN"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            Button("Hornell, NY", action: { selectedLocation = "Hornell, NY"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            Button("Rochester, NY", action: { selectedLocation = "Rochester, NY"
                                Analytics.setUserProperty(selectedLocation, forName: "location_preference")
                            })
                            
                        } label: {
                            Image(systemName: "chevron.down") // Your button text
                                .frame(alignment: .trailing)
                                .padding(9)
                                .background(Color(hex: "c7972b"))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.trailing)
                            
                        }
                    }
                    
                    
                    
                }
                
                Text("Contact us at: info@pointguarduniversity.com to update or change password/email")
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil) // Allow unlimited lines
                    .font(.caption)
                    .padding()
                
                
                Button("Delete Account") {
                    self.showDeleteConfirmation = true // Show the confirmation alert
                }
                .frame(alignment: .trailing)
                .foregroundColor(.red)
                .padding()
                
                //                .padding()
                
                Button("Save Changes") {
                    var updates: [String: Any] = [:]
                    var changesDetected = false
                    
                    if name != initialName {
                        updates["name"] = name
                        changesDetected = true
                    }
                    if phoneNumber != initialPhoneNumber { // Assuming you have an initialPhoneNumber
                        updates["phoneNumber"] = phoneNumber
                        changesDetected = true
                    }
                    if selectedLocation != initialLocation { // Assuming you have an initialLocation
                        updates["location"] = selectedLocation
                        changesDetected = true
                    }
                    
                    if changesDetected {
                        guard let userID = Auth.auth().currentUser?.uid else { return }
                        
                        db.collection("users").document(userID).updateData(updates) { err in
                            if let err = err {
                                self.alertMessage = "Error updating document: \(err.localizedDescription)"
                                self.showAlert = true
                            } else {
                                self.alertMessage = "Saved Successfully."
                                self.showAlert = true
                                
                                // Update initial values to reflect the saved changes
                                self.initialName = self.name
                                // Update other initial values as necessary
                            }
                        }
                    } else {
                        self.alertMessage = "No changes detected."
                        self.showAlert = true
                    }
                }
                .padding(EdgeInsets(top: 15, leading: 50, bottom: 15, trailing: 50))
                .background(Color(hex: "0f2d53"))
                .foregroundColor(.white)
                .font(.title3)
                .bold()
                .cornerRadius(37)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Notification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteUserAccount() // Call the deletion function if the user confirms
                    },
                    secondaryButton: .cancel()
                )
            }
            .fullScreenCover(isPresented: $shouldShowLoginView, content: {
                LoginView()
            })
            .onAppear {
                loadUserData()
                self.selectedImage = self.loadImage()
                
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $isImagePickerPresented)
                    .onDisappear {
                        if let selectedImage = selectedImage {
                            saveImage(selectedImage)
                        }
                    }
            }
        }
        
        Spacer()
        
        FooterMenu()

        
    }
    
    
    private func loadUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userID).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    self.name = data?["name"] as? String ?? "User"
                    self.phoneNumber = data?["phoneNumber"] as? String ?? ""
                    self.selectedLocation = data?["location"] as? String ?? "Location"
                    // Set initial values for comparison if you're checking for changes
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    
    
    private func updateNameInFirestore() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userID).updateData([
            "name": self.name
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                self.alertMessage = "Failed to save changes."
                self.showAlert = true
            } else {
                print("Document successfully updated")
                self.alertMessage = "Saved successfully."
                self.showAlert = true
                self.initialName = self.name // Update initialName to the new name
            }
        }
    }
    
    
    func saveImage(_ image: UIImage) {
        if let data = image.jpegData(compressionQuality: 1) ?? image.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("savedImage.png")
            try? data.write(to: filename)
            
            UserDefaults.standard.set(filename.path, forKey: "savedImagePath")
        }
    }
    
    func loadImage() -> UIImage? {
        if let path = UserDefaults.standard.string(forKey: "savedImagePath"),
           let imageData = FileManager.default.contents(atPath: path) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func resetImage() {
        UserDefaults.standard.removeObject(forKey: "savedImagePath")
        selectedImage = nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func deleteUserAccount() {
        guard let user = Auth.auth().currentUser else { return }
        let userEmail = user.email ?? "No email" // Get the user's email
        let deletionDate = Date() // Capture the current date and time of deletion
        
        // Data to be saved in the 'deleted_accounts' collection
        let deletedAccountData: [String: Any] = [
            "email": userEmail,
            "deletionDate": Timestamp(date: deletionDate), // Use Firestore Timestamp for the date
            // Include any other relevant information here
        ]
        
        // Step 1: Save deleted user information to Firestore
        db.collection("deleted_accounts").addDocument(data: deletedAccountData) { err in
            if let err = err {
                self.alertMessage = "Error saving deleted account info: \(err.localizedDescription)"
                self.showAlert = true
            } else {
                // Proceed with deleting the user's Firestore data and Firebase Authentication account
                let userId = user.uid
                db.collection("users").document(userId).delete() { [self] err in
                    if let err = err {
                        self.alertMessage = "Error removing user data: \(err.localizedDescription)"
                        self.showAlert = true
                    } else {
                        // Delete the user account from Firebase Authentication
                        user.delete { [self] error in
                            if let error = error {
                                self.alertMessage = "Error deleting user account: \(error.localizedDescription)"
                                self.showAlert = true
                            } else {
                                self.alertMessage = "Account deleted successfully."
                                self.showAlert = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Optional delay to show the alert message
                                    self.shouldShowLoginView = true // Trigger navigation to LoginView
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    
}
   


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

#Preview {
    EditProfileView()
}
