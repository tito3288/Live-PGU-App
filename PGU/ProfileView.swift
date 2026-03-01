//
//  ProfileView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ProfileView: View {
    @State private var isMenuOpen: Bool = false

    @State private var showingLogoutAlert = false
    @State private var navigateToLogin = false

    @State private var userName = "Full Name"  // State variable for user's name
    @State private var userEmail = "email@example.com"  // State variable for user's email

    @State private var selectedImage: UIImage? = nil

    var body: some View {
        
        ZStack {
            // Combined Main content and List in a single VStack
            VStack(spacing: 0) {
                HamburgerMenu(isMenuOpen: $isMenuOpen)
                    .navigationBarBackButtonHidden(true)
                    .frame(height: 50)
                    .padding(.bottom, 30)
                
                let goldenColor = Color(red: 0.85, green: 0.65, blue: 0.13)
                
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
                        .frame(width: 90, height: 90)
                        .padding(30)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color(hex: "c7972b")))
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color(hex: "c7972b"), lineWidth: 2))
                }
                
                
                Text(userName)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                Text(userEmail)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                ScrollView {
                    VStack {
                        ForEach(["Edit Profile", "Camp Information", "Terms & Conditions", "Contact Us", "FAQ", "Log Out"], id: \.self) { item in
                            if item == "Terms & Conditions" {
                                // Navigation link for "Terms and Condition"
                                NavigationLink(destination: TermsandCondView()) {
                                    HStack {
                                        Text(item)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(goldenColor)
                                    }
                                }
                                .padding()
                                .foregroundColor(.black)
                                
                            }else if item == "FAQ"{
                                NavigationLink(destination: FaqView()) {
                                    HStack {
                                        Text(item)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(goldenColor)
                                    }
                                }
                                .padding()
                                .foregroundColor(.black)
                                
                            }else if item == "Camp Information"{
                                NavigationLink(destination: CampInfoView()) {
                                    HStack {
                                        Text(item)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(goldenColor)
                                    }
                                }
                                .padding()
                                .foregroundColor(.black)
                                
                            }else if item == "Edit Profile"{
                                NavigationLink(destination: EditProfileView()) {
                                    HStack {
                                        Text(item)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(goldenColor)
                                    }
                                }
                                .padding()
                                .foregroundColor(.black)
                                
                                
                            } else if item == "Log Out" {
                                // Log Out item
                                Button(action: {
                                    self.showingLogoutAlert = true
                                }) {
                                    HStack {
                                        Text(item)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(goldenColor)
                                    }
                                }
                                .padding()
                                .foregroundColor(.black)
                                
                            }else if item == "Contact Us"{
                                NavigationLink(destination: ContactView()) {
                                    HStack {
                                        Text(item)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(goldenColor)
                                    }
                                }
                                .padding()
                                .foregroundColor(.black)
                                
                            }else {
                                // Regular items
                                HStack {
                                    Text(item)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(goldenColor)
                                }
                                .padding()
                            }
                            
                            NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                                EmptyView()
                            }
                        }
                    }
                }
                
//                FooterMenu()
                
                Divider()
                
//                HStack {
//                    
//                    Spacer()
//
////                    NavigationLink(destination: ProfileView()) {
//                        VStack{
//                            Image(systemName: "person")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.gray)
//                                .frame(width: 25, height: 25)// Example icon
//                            Text("Profile")
//                                .foregroundColor(.gray)
//                                .fontWeight(.bold)
//
//                        }
////                    }
//
//                        
//                    
//                    Spacer()
//                    
//                    NavigationLink(destination: InboxView()) {
//                        VStack{
//                            Image(systemName: "tray.full")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.gray)
//                                .frame(width: 25, height: 25)// Example icon
//                            Text("Inbox")
//                                .foregroundColor(.gray)
//                                .fontWeight(.bold)
//
//                        }
//                    }
//
//                        
//                    
//                    Spacer()
//                    
//
//                    NavigationLink(destination: CampsView()) {
//                        VStack{
//                            Image(systemName: "mappin.and.ellipse")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.gray)
//                                .frame(width: 25, height: 25)// Example icon
//                            Text("Camps")
//                                .foregroundColor(.gray)
//                                .fontWeight(.bold)
//
//                        }
//                    }
//
//                        
//        //            }
//                    
//                    Spacer()
//                    
//                    NavigationLink(destination: ResourcesView()) {
//
//                        VStack{
//                            Image(systemName: "basketball")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.gray)
//                                .frame(width: 25, height: 25)// Example icon
//                            Text("Resources")
//                                .foregroundColor(.gray)
//                                .fontWeight(.bold)
//                        }
//                        
//                    }
//
//                    Spacer()
//
//                }
//                .padding(.top)
//                .background(Color.white)
                
                FooterMenu()
                
                
            }
            .onAppear(perform: loadUserData)

            // Sliding menu
            if isMenuOpen {
                MenuView(isMenuOpen: $isMenuOpen)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(1) // Ensure the menu is on top
            }
        }
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("Are you sure you want to log out?"),
                primaryButton: .destructive(Text("Yes")) {
                    // Perform logout operation
                    do {
                        try Auth.auth().signOut()
                        self.navigateToLogin = true
                    } catch let signOutError {
                        print("Error signing out: \(signOutError)")
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    
    private func loadUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["name"] as? String ?? "User"
                self.userEmail = data?["email"] as? String ?? "email@example.com"
                
                
                // Load the profile image
                self.selectedImage = loadImage()

            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func loadImage() -> UIImage? {
        if let path = UserDefaults.standard.string(forKey: "savedImagePath"),
           let imageData = FileManager.default.contents(atPath: path) {
            return UIImage(data: imageData)
        }
        return nil
    }
}

#Preview {
    ProfileView()
}
