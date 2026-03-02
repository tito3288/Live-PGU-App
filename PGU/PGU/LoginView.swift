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

    @Environment(\.dismiss) private var dismiss

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isAuthenticated = false
    @State private var showAlertReset = false
    @State private var emailReset = ""
    @State private var showPasswordResetView = false

    // MARK: - Design Tokens
    private let navy = Color(hex: "0f2d53")
    private let gold = Color(hex: "c7972b")
    private let fieldBackground = Color(hex: "f5f5f5")
    private let fieldBorder = Color(hex: "e0e0e0")

    var body: some View {
        if isAuthenticated {
            HomeView()
        } else {
            ZStack {
                navy.ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - Navy Header
                    headerSection

                    // MARK: - White Card
                    ScrollView {
                        VStack(spacing: 0) {
                            cardContent
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 40)
                    }
                    .background(Color.white)
                    .clipShape(RoundedCorner(radius: 28, corners: [.topLeft, .topRight]))
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                    }
                }
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .alert(isPresented: $showAlert, content: loginFailedAlert)
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 6) {
            HStack(spacing: 0) {
                Text("Welcome Back")
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(.white)
                Text(".")
                    .font(.system(size: 34, weight: .heavy))
                    .foregroundColor(gold)
            }

            Text("Sign in to access your camps & resources")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.top, 10)
        .padding(.bottom, 24)
    }

    // MARK: - Card Content
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Email field
            VStack(alignment: .leading, spacing: 8) {
                Text("EMAIL ADDRESS")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)

                HStack(spacing: 12) {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .frame(width: 20)

                    TextField("you@example.com", text: $email)
                        .font(.system(size: 15))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(14)
                .background(fieldBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(fieldBorder, lineWidth: 1)
                )
            }

            // Password field
            VStack(alignment: .leading, spacing: 8) {
                Text("PASSWORD")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)

                HStack(spacing: 12) {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .frame(width: 20)

                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .font(.system(size: 15))
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        SecureField("Password", text: $password)
                            .font(.system(size: 15))
                    }

                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 15))
                    }
                }
                .padding(14)
                .background(fieldBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(fieldBorder, lineWidth: 1)
                )
            }

            // Forgot Password
            HStack {
                Spacer()
                Button(action: {
                    showPasswordResetView = true
                }) {
                    Text("Forgot Password?")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(gold)
                }
                .sheet(isPresented: $showPasswordResetView) {
                    PasswordResetView(emailReset: $emailReset)
                }
            }

            // Sign In Button
            Button(action: {
                loginUser(email: email, password: password)
            }) {
                Text("Sign In")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            .padding(.top, 6)

            // Sign Up Link
            HStack {
                Spacer()
                Text("Don't have an account? ")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up Free")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(gold)
                }
                Spacer()
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Firebase Auth
    func loginUser(email: String, password: String) {
        print("Attempting to sign in with Email: \(email), Password: \(password)")

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                alertMessage = "Login failed: \(error.localizedDescription)"
                showAlert = true
            } else {
                print("User signed in successfully")
                isAuthenticated = true
            }
        }
    }

    // MARK: - Alert
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
    NavigationStack {
        LoginView()
    }
}




