//
//  HomeView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/28/23.
//

import SwiftUI
import Firebase // Ensure Firebase is imported
import UserNotifications


struct HomeView: View {
    
    @EnvironmentObject var navigationState: NavigationState

    var body: some View {
        
        ZStack {
            // Main content with light background
            Color(red: 0.96, green: 0.96, blue: 0.96)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header with hamburger menu, logo, and notification bell
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
                    
                    // PG|U Logo
                    HStack(spacing: 4) {
                        Text("PG")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        Rectangle()
                            .fill(Color(hex: "c7972b"))
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
                        
                        // Notification dot
                        Circle()
                            .fill(Color(hex: "c7972b"))
                            .frame(width: 8, height: 8)
                            .offset(x: 4, y: -4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                .navigationBarBackButtonHidden(true)
                
                // Scrollable content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Welcome Section
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Good morning")
                                Image(systemName: "hand.wave.fill")
                                    .foregroundColor(.yellow)
                            }
                            .font(.body)
                            .foregroundColor(.gray)
                            
                            HStack(spacing: 4) {
                                Text("Welcome to")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            
                            HStack(spacing: 4) {
                                Text("PG")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Rectangle()
                                    .fill(Color(hex: "c7972b"))
                                    .frame(width: 3, height: 32)
                                
                                Text("U")
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Hero Card with Basketball Image
                        ZStack(alignment: .bottomLeading) {
                            // Basketball hoop background image
                            Image("logo2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 280)
                                .clipped()
                                .cornerRadius(20)
                            
                            // Dark overlay for better text visibility
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, Color.black.opacity(0.7)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .cornerRadius(20)
                            
                            // Content overlay
                            VStack(alignment: .leading, spacing: 12) {
                                // 2025 Summer Tour Badge
                                HStack(spacing: 6) {
                                    Image(systemName: "basketball.fill")
                                        .font(.caption)
                                        .foregroundColor(Color(hex: "c7972b"))
                                    Text("2026 SUMMER TOUR")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(20)
                                
                                // Main headline
                                Text("4 States, 4 Stops,\nUnlimited Memories")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                
                                // CTA Button
                                NavigationLink(destination: CampsView()) {
                                    Text("SIGN UP FOR CAMP")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color(hex: "c7972b"))
                                        .cornerRadius(25)
                                }
                            }
                            .padding(20)
                        }
                        .padding(.horizontal, 20)
                        
                        // Tour at a Glance Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("TOUR AT A GLANCE")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 12) {
                                // States Card
                                VStack(spacing: 8) {
                                    HStack(spacing: 2) {
                                        Text("4")
                                            .font(.system(size: 32, weight: .bold))
                                            .foregroundColor(.black)
//                                        Image(systemName: "plus")
//                                            .font(.caption)
//                                            .foregroundColor(Color(hex: "c7972b"))
//                                            .offset(y: -8)
                                    }
                                    Text("STATES")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color.white)
                                .cornerRadius(12)
                                
                                // Stops Card
                                VStack(spacing: 8) {
                                    Text("4")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.black)
                                    Text("STOPS")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color.white)
                                .cornerRadius(12)
                                
                                // Memories Card
                                VStack(spacing: 8) {
                                    Text("∞")
                                        .font(.system(size: 32, weight: .bold))
                                        .foregroundColor(.black)
                                    Text("MEMORIES")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Upcoming Camps Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("UPCOMING CAMPS")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                NavigationLink(destination: CampsView()) {
                                    HStack(spacing: 4) {
                                        Text("See All")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(hex: "c7972b"))
                                        Image(systemName: "arrow.right")
                                            .font(.caption)
                                            .foregroundColor(Color(hex: "c7972b"))
                                    }
                                }
                            }
                            
                            // Horizontal scrolling camp cards
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    CampCard(
                                        imageName: "logo2",
                                        location: "Limon, CO",
                                        dates: "June 8-11",
                                        status: "Opens 3/23",
                                        statusColor: Color(hex: "c7972b")
                                    )

                                    CampCard(
                                        imageName: "logo2",
                                        location: "Goodland, KS",
                                        dates: "June 15-18",
                                        status: "Opens 3/23",
                                        statusColor: Color(hex: "c7972b")
                                    )

                                    CampCard(
                                        imageName: "logo2",
                                        location: "Marion, KS",
                                        dates: "June 22-25",
                                        status: "Opens 3/23",
                                        statusColor: Color(hex: "c7972b")
                                    )

                                    CampCard(
                                        imageName: "logo2",
                                        location: "South Bend, IN",
                                        dates: "June 29 - July 2",
                                        status: "Opens 3/23",
                                        statusColor: Color(hex: "c7972b")
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                            .padding(.horizontal, -20)
                        }
                        .padding(.horizontal, 20)
                        
                        // Add bottom padding for tab bar
                        Color.clear
                            .frame(height: 80)
                    }
                }
                
            }
            
            // Sliding menu overlay
            if navigationState.isMenuOpen {
                MenuView(isMenuOpen: $navigationState.isMenuOpen, activePage: .home)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
            }
        }
        .toolbar(navigationState.isMenuOpen ? .hidden : .visible, for: .tabBar)
    }
    
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Handle the error case
                    print("Notification authorization request error: \(error)")
                } else {
                    print("Notification authorization granted: \(granted)")
                    if granted {
                        // Proceed to register for remote notifications
                        UIApplication.shared.registerForRemoteNotifications()
                    } else {
                        // Handle the case where the user denies permissions
                        print("User denied notification permissions")
                    }
                }
            }
        }
    }
}

// MARK: - Camp Card Component
struct CampCard: View {
    let imageName: String
    let location: String
    let dates: String
    let status: String
    let statusColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 120)
                .clipped()
                .cornerRadius(12, corners: [.topLeft, .topRight])
            
            // Details
            VStack(alignment: .leading, spacing: 8) {
                Text(location)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                
                Text(dates)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Status badge
                Text(status)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(statusColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.15))
                    .cornerRadius(6)
            }
            .padding(12)
            .frame(width: 160, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// Extension to round specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    HomeView()
}
