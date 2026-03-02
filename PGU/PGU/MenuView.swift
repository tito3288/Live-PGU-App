//
//  MenuView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


enum ActivePage: String {
    case home, inbox, camps, resources, calendar, scholarships, settings, profile, contact, campInfo, none
}

struct MenuView: View {

    @Binding var isMenuOpen: Bool
    @EnvironmentObject var navigationState: NavigationState
    var activePage: ActivePage = .none
    @State private var showingLogoutAlert = false
    @State private var navigateToLogin = false

    @State private var userName = "John Doe"

    @State private var navigateToCalendar = false
    @State private var navigateToContactUs = false
    @State private var navigateToProfile = false
    @State private var navigateToScholarships = false

    private let navyBg = Color(red: 0.06, green: 0.18, blue: 0.33)
    private let navyLight = Color(red: 0.10, green: 0.24, blue: 0.40)
    private let gold = Color(red: 0.78, green: 0.59, blue: 0.17)

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Dim background tap to close
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isMenuOpen = false }
                    }

                // Menu panel
                VStack(alignment: .leading, spacing: 0) {

                    // Header: PG|U + close button
                    HStack {
                        HStack(spacing: 4) {
                            Text("PG")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Rectangle()
                                .fill(Color(hex: "c7972b"))
                                .frame(width: 3, height: 24)
                            Text("U")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }

                        Spacer()

                        Button(action: {
                            withAnimation { isMenuOpen = false }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 32, height: 32)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    .padding(.bottom, 20)

                    // User profile card
                    HStack(spacing: 12) {
                        // Initials avatar
                        ZStack {
                            Circle()
                                .fill(gold)
                                .frame(width: 48, height: 48)
                            Text(initials(from: userName))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(userName)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                            Text("Grade 9 \u{00B7} Basketball Player")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.6))
                        }

                        Spacer()

                        Text("PRO")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)

                    // Scrollable menu content
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 0) {

                            // MAIN MENU label
                            Text("MAIN MENU")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.horizontal, 24)
                                .padding(.bottom, 12)

                            // Home
                            MenuRow(icon: "house.fill", title: "Home", subtitle: "Dashboard & updates", isHighlighted: activePage == .home) {
                                withAnimation {
                                    isMenuOpen = false
                                }
                                navigationState.selectedTab = .home
                            }

                            // Inbox
                            MenuRow(icon: "tray.fill", title: "Inbox", subtitle: "Messages & announcements", badgeCount: 3, isHighlighted: activePage == .inbox) {
                                withAnimation {
                                    isMenuOpen = false
                                }
                                navigationState.selectedTab = .inbox
                            }

                            // Find Camps
                            MenuRow(icon: "mappin", title: "Find Camps", subtitle: "2025 Summer Tour stops", isHighlighted: activePage == .camps) {
                                withAnimation {
                                    isMenuOpen = false
                                }
                                navigationState.selectedTab = .camps
                            }

                            // Resources
                            MenuRow(icon: "basketball.fill", title: "Resources", subtitle: "Podcast, videos & clips", isHighlighted: activePage == .resources) {
                                withAnimation {
                                    isMenuOpen = false
                                }
                                navigationState.selectedTab = .resources
                            }

                            // Divider
                            Rectangle()
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 1)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)

                            // MORE label
                            Text("MORE")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white.opacity(0.4))
                                .padding(.horizontal, 24)
                                .padding(.bottom, 12)

                            // Calendar
                            MenuRow(icon: "calendar", title: "Calendar", subtitle: "Camp schedule & events", isHighlighted: activePage == .calendar) {
                                navigateToCalendar = true
                            }
                            .background(NavigationLink(destination: CalendarView(), isActive: $navigateToCalendar) { EmptyView() }.hidden())

                            // Scholarships
                            MenuRow(icon: "trophy.fill", title: "Scholarships", subtitle: "Apply for financial aid", isHighlighted: activePage == .scholarships) {
                                navigateToContactUs = true
                            }
                            .background(NavigationLink(destination: ContactView(), isActive: $navigateToContactUs) { EmptyView() }.hidden())

                            // Share App
                            MenuRow(icon: "square.and.arrow.up", title: "Share App", subtitle: "Invite teammates") {
                                shareApp()
                            }

                            // Divider
                            Rectangle()
                                .fill(Color.white.opacity(0.08))
                                .frame(height: 1)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)

                            // Bottom links
                            MenuSimpleRow(icon: "gearshape.fill", title: "Settings") {
                                navigateToProfile = true
                            }
                            .background(NavigationLink(destination: ProfileView(), isActive: $navigateToProfile) { EmptyView() }.hidden())

                            MenuSimpleRow(icon: "questionmark.circle.fill", title: "Help & Support") {
                                navigateToContactUs = true
                            }

                            // Sign Out
                            Button(action: {
                                showingLogoutAlert = true
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 16))
                                        .foregroundColor(.red)
                                    Text("Sign Out")
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                            }

                            Spacer().frame(height: 60)
                        }
                    }
                }
                .frame(width: min(geometry.size.width * 0.82, 340))
                .background(navyBg.ignoresSafeArea())
            }
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Are you sure you want to log out?"),
                    primaryButton: .destructive(Text("Yes")) {
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

            NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                EmptyView()
            }
        }
        .onAppear(perform: loadUserData)
    }

    // MARK: - Helpers

    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.count > 1 ? parts.last!.prefix(1) : ""
        return "\(first)\(last)".uppercased()
    }

    private func shareApp() {
        let message = "Check out the PG|U app!"
        let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }

    private func loadUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["name"] as? String ?? "User"
            } else {
                print("Document does not exist")
            }
        }
    }
}

// MARK: - Menu Row (icon circle + title + subtitle + chevron)
struct MenuRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var badgeCount: Int = 0
    var isHighlighted: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                // Orange highlight bar
                if isHighlighted {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(hex: "c7972b"))
                        .frame(width: 4, height: 48)
                        .padding(.trailing, 20)
                } else {
                    Spacer().frame(width: 24)
                }

                // Icon circle
                ZStack {
                    Circle()
                        .fill(isHighlighted ? Color(hex: "c7972b").opacity(0.2) : Color.white.opacity(0.08))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(isHighlighted ? Color(hex: "c7972b") : .white.opacity(0.8))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.leading, 12)

                Spacer()

                if badgeCount > 0 {
                    Text("\(badgeCount)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 22, height: 22)
                        .background(Color(hex: "c7972b"))
                        .clipShape(Circle())
                        .padding(.trailing, 4)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.trailing, 24)
            }
            .padding(.vertical, 12)
            .background(isHighlighted ? Color.white.opacity(0.05) : Color.clear)
        }
    }
}

// MARK: - Simple Menu Row (icon + title, no circle)
struct MenuSimpleRow: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.6))
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    MenuView(isMenuOpen: .constant(true), activePage: .home)
}
