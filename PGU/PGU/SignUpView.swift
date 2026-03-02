//
//  SignUpView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/31/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseAnalytics


struct SignUpView: View {

    @Environment(\.dismiss) private var dismiss

    // MARK: - Step State
    @State private var currentStep = 1

    // MARK: - Step 1 Fields
    @State private var fullName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    // MARK: - Step 2 Fields
    @State private var selectedLocation = "Select a camp location"
    @State private var selectedGrade = "Select your grade"
    @State private var yearsAttended = 0
    @State private var campsAttended = 0

    // MARK: - Step 3 Fields
    @State private var agreedToTerms = false
    @State private var optedIntoEmails = false

    // MARK: - Alerts / Auth
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isAuthenticated = false

    // MARK: - Design Tokens
    private let navy = Color(hex: "0f2d53")
    private let gold = Color(hex: "c7972b")
    private let fieldBackground = Color(hex: "f5f5f5")
    private let fieldBorder = Color(hex: "e0e0e0")

    private let campLocations = [
        "Dodge City, KS", "Limon, CO", "Goodland, KS", "Canton, KS",
        "Grand Rapids, MI", "Lafayette, IN", "South Bend, IN",
        "Indianapolis, IN", "Hornell, NY", "Rochester, NY"
    ]

    private let grades = [
        "6th Grade", "7th Grade", "8th Grade", "9th Grade",
        "10th Grade", "11th Grade", "12th Grade"
    ]

    var body: some View {
        if isAuthenticated {
            HomeView()
        } else {
            ZStack {
                navy.ignoresSafeArea()

                VStack(spacing: 0) {
                    // MARK: - Header
                    headerSection

                    // MARK: - Progress Bar
                    progressBar
                        .padding(.horizontal, 30)
                        .padding(.top, 18)
                        .padding(.bottom, 24)

                    // MARK: - White Card
                    ScrollView {
                        VStack(spacing: 0) {
                            Group {
                                switch currentStep {
                                case 1: step1View
                                case 2: step2View
                                case 3: step3View
                                default: EmptyView()
                                }
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 6) {
            HStack(spacing: 3) {
                Text("Join")
                    .font(.system(size: 28, weight: .bold))
                    .italic()
                    .foregroundColor(.white)

                Text("PG")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.white)

                Rectangle()
                    .fill(gold)
                    .frame(width: 2.5, height: 22)

                Text("U")
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(.white)
            }

            Text("Create your account to register for camps")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
        }
        .padding(.top, 10)
    }

    // MARK: - Progress Bar
    private var progressBar: some View {
        HStack(spacing: 6) {
            ForEach(1...3, id: \.self) { step in
                Capsule()
                    .fill(step <= currentStep ? gold : Color.white.opacity(0.2))
                    .frame(height: 4)
            }
        }
    }

    // MARK: - Step 1: Personal Info
    private var step1View: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader(title: "Personal Info", step: "Step 1 of 3")

            // Full Name
            fieldRow(icon: "person.fill", placeholder: "Full Name", text: $fullName)

            // Email
            fieldRow(icon: "envelope.fill", placeholder: "Email Address", text: $email, keyboardType: .emailAddress)

            // Phone Number
            fieldRow(icon: "phone.fill", placeholder: "Phone Number", text: $phoneNumber, keyboardType: .phonePad)

            // Password
            passwordField

            // Continue Button
            Button(action: { validateAndAdvance() }) {
                HStack {
                    Text("Continue")
                        .font(.system(size: 17, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(navy)
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .padding(.top, 6)

            // Sign In Link
            HStack {
                Spacer()
                Text("Already have an account? ")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                NavigationLink(destination: LoginView()) {
                    Text("Sign In")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(navy)
                }
                Spacer()
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Step 2: Camp Details
    private var step2View: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader(title: "Camp Details", step: "Step 2 of 3")

            // Nearest Camp Location
            VStack(alignment: .leading, spacing: 8) {
                Text("Nearest Camp Location")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)

                Menu {
                    ForEach(campLocations, id: \.self) { location in
                        Button(location) {
                            selectedLocation = location
                            Analytics.logEvent("signup_location", parameters: [
                                "location": location
                            ])
                            Analytics.setUserProperty(location, forName: "location_preference")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(selectedLocation == "Select a camp location" ? .gray : navy)
                            .font(.system(size: 18))
                        Text(selectedLocation)
                            .font(.system(size: 15))
                            .foregroundColor(selectedLocation == "Select a camp location" ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(14)
                    .background(fieldBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(fieldBorder, lineWidth: 1)
                    )
                }
            }

            // Grade
            VStack(alignment: .leading, spacing: 8) {
                Text("Grade")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)

                Menu {
                    ForEach(grades, id: \.self) { grade in
                        Button(grade) {
                            selectedGrade = grade
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .foregroundColor(selectedGrade == "Select your grade" ? .gray : navy)
                            .font(.system(size: 18))
                        Text(selectedGrade)
                            .font(.system(size: 15))
                            .foregroundColor(selectedGrade == "Select your grade" ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(14)
                    .background(fieldBackground)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(fieldBorder, lineWidth: 1)
                    )
                }
            }

            // Years Attended
            stepperRow(icon: "calendar", label: "Years Attended PG|U", value: $yearsAttended)

            // Camps Attended
            stepperRow(icon: "tent.fill", label: "Number of Camps Attended", value: $campsAttended)

            // Bottom Buttons
            HStack(spacing: 12) {
                Button(action: { withAnimation(.easeInOut(duration: 0.3)) { currentStep = 1 } }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(navy)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .stroke(navy, lineWidth: 1.5)
                        )
                }

                Button(action: { validateAndAdvance() }) {
                    HStack {
                        Text("Continue")
                            .font(.system(size: 17, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(navy)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }
            }
            .padding(.top, 6)
        }
    }

    // MARK: - Step 3: Almost Done
    private var step3View: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader(title: "Almost Done!", step: "Step 3 of 3")

            // Profile Preview Card
            VStack(spacing: 16) {
                // Avatar + Name
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(gold)
                            .frame(width: 52, height: 52)
                        Text(initials(from: fullName))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(fullName.isEmpty ? "Your Name" : fullName)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(navy)
                        Text(email.isEmpty ? "email@example.com" : email)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }

                Divider()

                // 2x2 Info Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    summaryItem(icon: "mappin.circle.fill", label: "Location",
                                value: selectedLocation == "Select a camp location" ? "—" : selectedLocation)
                    summaryItem(icon: "graduationcap.fill", label: "Grade",
                                value: selectedGrade == "Select your grade" ? "—" : selectedGrade)
                    summaryItem(icon: "calendar", label: "Years",
                                value: "\(yearsAttended)")
                    summaryItem(icon: "tent.fill", label: "Camps",
                                value: "\(campsAttended)")
                }
            }
            .padding(18)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(fieldBorder, lineWidth: 1)
            )

            // Terms Checkbox
            Button(action: { agreedToTerms.toggle() }) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                        .font(.system(size: 22))
                        .foregroundColor(agreedToTerms ? gold : .gray)

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 0) {
                            Text("I agree to the ")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            NavigationLink(destination: TermsandCondView()) {
                                Text("Terms & Conditions")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(navy)
                                    .underline()
                            }
                        }
                        HStack(spacing: 0) {
                            Text("and ")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                            NavigationLink(destination: TermsandCondView()) {
                                Text("Privacy Policy")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(navy)
                                    .underline()
                            }
                            Text(" of Point Guard U.")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                    }
                }
            }

            // Marketing Opt-in Checkbox
            Button(action: { optedIntoEmails.toggle() }) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: optedIntoEmails ? "checkmark.square.fill" : "square")
                        .font(.system(size: 22))
                        .foregroundColor(optedIntoEmails ? gold : .gray)

                    Text("Send me camp updates, early-bird deals, and announcements via email.")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
            }

            // Bottom Buttons
            HStack(spacing: 12) {
                Button(action: { withAnimation(.easeInOut(duration: 0.3)) { currentStep = 2 } }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(navy)
                        .frame(width: 48, height: 48)
                        .overlay(
                            Circle()
                                .stroke(navy, lineWidth: 1.5)
                        )
                }

                Button(action: { validateAndAdvance() }) {
                    HStack(spacing: 8) {
                        Text("🏀")
                            .font(.system(size: 16))
                        Text("Create My Account")
                            .font(.system(size: 17, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(agreedToTerms ? gold : gold.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }
                .disabled(!agreedToTerms)
            }
            .padding(.top, 6)
        }
    }

    // MARK: - Shared Components

    private func sectionHeader(title: String, step: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(step)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(gold)
                .textCase(.uppercase)
                .tracking(1)

            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(navy)

            Rectangle()
                .fill(fieldBorder)
                .frame(height: 1)
                .padding(.top, 4)
        }
        .padding(.bottom, 4)
    }

    private func fieldRow(icon: String, placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .font(.system(size: 16))
                .frame(width: 20)

            TextField(placeholder, text: text)
                .font(.system(size: 15))
                .keyboardType(keyboardType)
                .autocapitalization(keyboardType == .emailAddress ? .none : .words)
                .disableAutocorrection(keyboardType == .emailAddress)
        }
        .padding(14)
        .background(fieldBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(fieldBorder, lineWidth: 1)
        )
    }

    private var passwordField: some View {
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

    private func stepperRow(icon: String, label: String, value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)

            HStack {
                Image(systemName: icon)
                    .foregroundColor(navy)
                    .font(.system(size: 18))

                Text(label)
                    .font(.system(size: 15))
                    .foregroundColor(.black)

                Spacer()

                HStack(spacing: 14) {
                    Button(action: { if value.wrappedValue > 0 { value.wrappedValue -= 1 } }) {
                        Image(systemName: "minus")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(navy)
                            .clipShape(Circle())
                    }

                    Text("\(value.wrappedValue)")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(navy)
                        .frame(minWidth: 20)

                    Button(action: { value.wrappedValue += 1 }) {
                        Image(systemName: "plus")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(navy)
                            .clipShape(Circle())
                    }
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
    }

    private func summaryItem(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(gold)

            VStack(alignment: .leading, spacing: 1) {
                Text(label)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(navy)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Helpers

    private func initials(from name: String) -> String {
        let parts = name.trimmingCharacters(in: .whitespaces).split(separator: " ")
        if parts.isEmpty { return "?" }
        if parts.count == 1 { return String(parts[0].prefix(1)).uppercased() }
        return (String(parts[0].prefix(1)) + String(parts[parts.count - 1].prefix(1))).uppercased()
    }

    // MARK: - Validation & Navigation

    private func validateAndAdvance() {
        switch currentStep {
        case 1:
            if fullName.trimmingCharacters(in: .whitespaces).isEmpty {
                alertMessage = "Please enter your full name."
                showAlert = true
            } else if !isValidEmail(email) {
                alertMessage = "Please enter a valid email address."
                showAlert = true
            } else if !isValidPhoneNumber(phoneNumber) {
                alertMessage = "Please enter a valid 10-digit phone number without any letters or special characters."
                showAlert = true
            } else if !isValidPassword(password) {
                alertMessage = "Password should be at least 6 characters long."
                showAlert = true
            } else {
                withAnimation(.easeInOut(duration: 0.3)) { currentStep = 2 }
            }
        case 2:
            if selectedLocation == "Select a camp location" {
                alertMessage = "Please select a camp location."
                showAlert = true
            } else if selectedGrade == "Select your grade" {
                alertMessage = "Please select your grade."
                showAlert = true
            } else {
                withAnimation(.easeInOut(duration: 0.3)) { currentStep = 3 }
            }
        case 3:
            if !agreedToTerms {
                alertMessage = "Please agree to the Terms & Conditions to continue."
                showAlert = true
            } else {
                signUpUser(email: email, password: password)
                updateDisplayName(name: fullName)
            }
        default:
            break
        }
    }

    // MARK: - Firebase Auth

    func signUpUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                alertMessage = "Account created successfully."
                showAlert = true

                Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                    AnalyticsParameterMethod: "Email"
                ])

                Analytics.logEvent("signup_location", parameters: [
                    "location": selectedLocation
                ])

                Analytics.setUserProperty(selectedLocation, forName: "location_preference")

                if let userId = authResult?.user.uid {
                    saveUserDataToFirestore(userId: userId, name: fullName, email: email, phoneNumber: phoneNumber, location: selectedLocation)
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    isAuthenticated = true
                }
            }
        }
    }

    // MARK: - Firestore Save

    func saveUserDataToFirestore(userId: String, name: String, email: String, phoneNumber: String, location: String) {
        let db = Firestore.firestore()
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "phoneNumber": phoneNumber,
            "location": location,
            "grade": selectedGrade,
            "yearsAttended": yearsAttended,
            "campsAttended": campsAttended,
            "agreedToTerms": agreedToTerms,
            "optedIntoEmails": optedIntoEmails
        ]

        db.collection("users").document(userId).setData(userData) { error in
            if let error = error {
                print("Error saving user data to Firestore: \(error)")
            } else {
                print("User data saved successfully to Firestore")
            }
        }
    }

    // MARK: - Display Name

    func updateDisplayName(name: String) {
        if let user = Auth.auth().currentUser {
            print("Display Name: \(user.displayName ?? "No name")")

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = name
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Error updating display name: \(error.localizedDescription)")
                } else {
                    print("Display name updated successfully")
                }
            }
        }
    }

    // MARK: - Validation Helpers

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberRegex = "^[0-9]{10}$"
        let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
        return phoneNumberTest.evaluate(with: phoneNumber)
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
