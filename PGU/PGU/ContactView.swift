//
//  ContactView.swift
//  PGU
//
//  Created by Bryan Arambula on 1/22/24.
//

import SwiftUI
import CoreLocation

struct ContactView: View {

    @EnvironmentObject var navigationState: NavigationState

    private let navy = Color(red: 0.06, green: 0.18, blue: 0.33)
    private let gold = Color(hex: "c7972b")

    var body: some View {
        ZStack {
            Color(red: 0.96, green: 0.96, blue: 0.96)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        withAnimation {
                            navigationState.isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.black)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("PG")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Rectangle()
                            .fill(gold)
                            .frame(width: 3, height: 24)
                        Text("U")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }

                    Spacer()

                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(.black)
                        Circle()
                            .fill(gold)
                            .frame(width: 8, height: 8)
                            .offset(x: 4, y: -4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)

                // Scrollable content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // Title
                        VStack(alignment: .leading, spacing: 4) {
                            Text("We'd love to hear from you")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            Text("Contact Us")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color(hex: "0f2d53"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                        // Hero card
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(gold.opacity(0.2))
                                    .frame(width: 64, height: 64)
                                Image(systemName: "basketball.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(gold)
                            }

                            HStack(spacing: 6) {
                                Text("PG")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                                Rectangle()
                                    .fill(gold)
                                    .frame(width: 3, height: 22)
                                Text("U")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            Text("Point Guard U — helping players develop their\ngame on and off the court. Reach out anytime.")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 28)
                        .padding(.horizontal, 20)
                        .background(navy)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)

                        // Phone card
                        ContactInfoCard(
                            icon: "phone.fill",
                            iconBgColor: Color(hex: "0f2d53"),
                            label: "PHONE",
                            labelColor: Color(hex: "0f2d53"),
                            title: "(574) 208-3941",
                            subtitle: "Mon – Fri, 9am – 5pm CT"
                        ) {
                            callPhoneNumber()
                        }
                        .padding(.horizontal, 20)

                        // Email card
                        ContactInfoCard(
                            icon: "envelope.fill",
                            iconBgColor: Color(hex: "0f2d53"),
                            label: "EMAIL",
                            labelColor: Color(hex: "0f2d53"),
                            title: "info@pointguarduniversity.com",
                            subtitle: "We reply within 24 hours"
                        ) {
                            openEmail()
                        }
                        .padding(.horizontal, 20)

                        // Address card
                        ContactInfoCard(
                            icon: "mappin.circle.fill",
                            iconBgColor: .green,
                            label: "ADDRESS",
                            labelColor: .green,
                            title: "201 W Monroe St",
                            subtitle: "South Bend, IN, 46601"
                        ) {
                            openMapForAddress()
                        }
                        .padding(.horizontal, 20)

                        // Follow Us
                        VStack(alignment: .leading, spacing: 12) {
                            Text("FOLLOW US")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(hex: "0f2d53"))

                            HStack(spacing: 12) {
                                SocialMediaButton(icon: "camera.fill", label: nil, color: .pink)
                                SocialMediaButton(icon: nil, label: "Twitter", color: .black)
                                SocialMediaButton(icon: "play.rectangle.fill", label: nil, color: .red)
                                SocialMediaButton(icon: "music.note", label: nil, color: .black)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        Spacer().frame(height: 30)
                    }
                }
            }

            // Sliding menu overlay
            if navigationState.isMenuOpen {
                MenuView(isMenuOpen: $navigationState.isMenuOpen, activePage: .contact)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(navigationState.isMenuOpen ? .hidden : .visible, for: .tabBar)
    }

    // MARK: - Actions

    func callPhoneNumber() {
        if let url = URL(string: "tel://5551234567"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }

    func openEmail() {
        if let url = URL(string: "mailto:info@pointguardu.com") {
            UIApplication.shared.open(url)
        }
    }

    func openMapForAddress() {
        let address = "123 Court Drive, Dodge City, KS 67801"
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("No location found")
                return
            }
            let coords = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            if let url = URL(string: "http://maps.apple.com/?daddr=\(coords)&dirflg=d") {
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: - Contact Info Card

struct ContactInfoCard: View {
    let icon: String
    let iconBgColor: Color
    let label: String
    let labelColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(iconBgColor)
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(label)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(labelColor)
                    Text(title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(14)
        }
    }
}

// MARK: - Social Media Button

struct SocialMediaButton: View {
    let icon: String?
    let label: String?
    let color: Color

    var body: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(color)
                }
                if let label = label {
                    Text(label)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(color)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.white)
            .cornerRadius(12)
        }
    }
}

#Preview {
    ContactView()
        .environmentObject(NavigationState.shared)
}
