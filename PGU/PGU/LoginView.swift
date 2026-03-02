//
//  SignupandLoginView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/30/23.
//

import SwiftUI
import FirebaseAuth
import AppTrackingTransparency
import AdSupport


struct LoginView: View {

//    @State private var searchText1 = "" // State variable to hold search text
//    @State private var searchText2 = "" // State variable to hold search text
    
    @State private var showAlert = false // New state variable for showing the alert
    @State private var alertMessage = "" // To hold the alert message
    
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible: Bool = false

    @State private var isAuthenticated = false
    
    @State private var showAlertReset = false
    @State private var emailReset = ""
    
    @State private var showPasswordResetView = false


    
    var body: some View {

        VStack{
       
            if isAuthenticated {
                HomeView() // Navigate to HomeView if authenticated
            } else {
                
                Spacer()
                
                Image("logo")
                    .resizable() // Allows the image to be resized
                    .scaledToFit() // Maintains the aspect ratio of the image
                // Specify the desired width and height
                    .frame(width: 200, height: 200)
                
                ZStack(alignment: .trailing) {
                    TextField("Email", text: $email)
                        .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 50)) // Adjust left padding
                        .background(.white)
                        .foregroundColor(Color(hex: "0f2d53"))
                        .font(.body)
                        .bold()
                        .cornerRadius(37)
                        .frame(width: 300) // Set a specific width
                        .overlay(
                            RoundedRectangle(cornerRadius: 37)
                                .stroke(Color(hex: "0f2d53"), lineWidth: 2) // Customize border color and line width
                        )
                    
                    Image(systemName: "person.fill")
                        .resizable() // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Keep the image aspect ratio
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(hex: "0f2d53")) // Adjust the color as needed
                        .padding(.trailing, 20) // Adjust the right padding to position the image
                    
                }
                .padding(.top, 0)
                
                ZStack(alignment: .trailing) {
                    if isPasswordVisible {
                        TextField("Password", text: $password) // TextField for visible password
                            .autocapitalization(.none) // Prevent automatic capitalization

                            .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 50))
                            .background(.white)
                            .foregroundColor(Color(hex: "0f2d53"))
                            .font(.body)
                            .bold()
                            .cornerRadius(37)
                            .frame(width: 300)
                            .overlay(
                                RoundedRectangle(cornerRadius: 37)
                                    .stroke(Color(hex: "0f2d53"), lineWidth: 2)
                            )
                    } else {
                        SecureField("Password", text: $password) // SecureField for hidden password
                            .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 50))
                            .background(.white)
                            .foregroundColor(Color(hex: "0f2d53"))
                            .font(.body)
                            .bold()
                            .cornerRadius(37)
                            .frame(width: 300)
                            .overlay(
                                RoundedRectangle(cornerRadius: 37)
                                    .stroke(Color(hex: "0f2d53"), lineWidth: 2)
                            )
                    }
                    
                    Button(action: {
                        self.isPasswordVisible.toggle() // Toggle the visibility state
//                        requestPermission()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.fill" : "eye.slash.fill") // Change icon based on visibility
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(hex: "0f2d53"))
                            .padding(.trailing, 20)
                    }
                }
                .padding(.top, 15)
                
                
                
                Button(action: {
                    self.showPasswordResetView = true
                    print("Forgot Password?")
                }) {
                    Text("Forgot Password?")
                        .padding(.top)
                        .foregroundColor(Color(hex: "c7972b"))
                }
                .sheet(isPresented: $showPasswordResetView) {
                    PasswordResetView(emailReset: $emailReset)
                }

        
                Spacer()
                
                HStack{
                    
                    NavigationLink(destination: SignUpView()){
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(Color(hex: "0f2d53"))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        loginUser(email: email, password: password)
                    }){
                        Text("Log In")
                            .padding(EdgeInsets(top: 15, leading: 30, bottom: 15, trailing: 30))
                            .background(Color(red: 0.78, green: 0.592, blue: 0.169))
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .cornerRadius(37)
                            .padding()
                        
                    }

                }
            }
   
        }
        .alert(isPresented: $showAlert, content: loginFailedAlert)
    }

    
    
    //MARK: LOGIC TO LOGIN USER AND REDIRECT USER TO HOMEVIEW.
    func loginUser(email: String, password: String) {
        print("Attempting to sign in with Email: \(email), Password: \(password)")

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                // Handle the error, maybe show an alert to the user
                alertMessage = "Login failed: \(error.localizedDescription)"
                showAlert = true // Show the alert
            } else {
                print("User signed in successfully")
                isAuthenticated = true // Set the authentication flag to true
                // Navigate to the main part of your app or update the view
            }
        }
    }
    
//    func requestPermission() {
//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization { status in
//                switch status {
//                case .authorized:
//                    // Tracking authorization dialog was shown
//                    // and we are authorized
//                    print("Authorized")
//                    
//                    // Now that we are authorized we can get the IDFA
//                    print(ASIdentifierManager.shared().advertisingIdentifier)
//                case .denied:
//                    // Tracking authorization dialog was
//                    // shown and permission is denied
//                    print("Denied")
//                case .notDetermined:
//                    // Tracking authorization dialog has not been shown
//                    print("Not Determined")
//                case .restricted:
//                    print("Restricted")
//                @unknown default:
//                    print("Unknown")
//                }
//            }
//        }
//    }

    
    //MARK: LOGIC TO DISPLAY ALERT IF LOGIN FAILED.
    private func loginFailedAlert() -> Alert {
        return Alert(title: Text("Login Failed"), message: Text("The password is invalid or the user does not have a password."), dismissButton: .default(Text("OK")))
    }
    


}



//MARK: LOGIC TO RESET PASSWORD AND DISPLAY SHEET WHEN USER CLICKS ON FORGOT PASSWORD BUTTON.
struct PasswordResetView: View {
    @Binding var emailReset: String
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Enter your email for password recovery")
                .font(.body)

            TextField("Email", text: $emailReset)
                .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 50)) // Adjust left padding
                .background(.white)
                .foregroundColor(Color(hex: "0f2d53"))
                .font(.body)
                .bold()
                .cornerRadius(37)
                .frame(width: 300) // Set a specific width
                .overlay(
                    RoundedRectangle(cornerRadius: 37)
                        .stroke(Color(hex: "0f2d53"), lineWidth: 2) // Customize border color and line width
                )

            Button("Submit") {
                resetPassword(email: emailReset)

                // Handle the password reset logic here
                print("Password reset for: \(emailReset)")
                // Close the view after submission
            }
            .padding(EdgeInsets(top: 15, leading: 50, bottom: 15, trailing: 50))
            .background(Color(red: 0.78, green: 0.592, blue: 0.169))
            .foregroundColor(.white)
            .font(.title3)
            .bold()
            .cornerRadius(37)
            .padding()
        }
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                requestPermission()
//            }
//        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Reset email sent successfully"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .padding()
    }
    
    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    
    private func resetPassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                // Handle the error - show an alert to the user
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
            } else {
                // Email sent successfully
                alertMessage = "Please check your email."
                showAlert = true
                emailReset = ""
            }
        }
    }
    
    
    //NEWLY ADDED PERMISSIONS FOR iOS 14

     
}






#Preview {
    LoginView()
}




