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
    
    @State private var isMenuOpen: Bool = false

    var body: some View {
        
        GeometryReader { geometry in // Use GeometryReader to access the view's size
            
            
            ZStack {
                // Main content
                
                VStack(spacing: 0) {
                    HamburgerMenu(isMenuOpen: $isMenuOpen)
                        .navigationBarBackButtonHidden(true)
                        .frame(height: 50)
                    //                    .padding(.bottom, 20)
                        .padding(.top, 10)
                    //                    .padding(.top, 30)
                        .zIndex(1) // Higher zIndex for the header
                    
                    Spacer()
                    
                    HStack {
                        ZStack {

                            
                            Image("logo2")
                                .resizable()
                                .aspectRatio(contentMode: geometry.size.width <= 320 ? .fit : .fill) // Dynamically change contentMode
                                .frame(width: geometry.size.width, height: geometry.size.height * (geometry.size.height >= 1300 ? 0.89 : 0.79))
                                .clipped() // Ensure the image does not overflow its bounds
                                .zIndex(0)
                            
                            
                            VStack {
                                Text("2025 SUMMER TOUR")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 180)
                                
                                Text("4 States, 8 Stops, Unlimited Memories")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                
                                NavigationLink(destination: CampsView()){
                                    Text("SIGN UP FOR CAMP")
                                        .padding(EdgeInsets(top: 15, leading: 50, bottom: 15, trailing: 50))
                                        .background(Color(red: 0.78, green: 0.592, blue: 0.169))
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .bold()
                                        .cornerRadius(37)
                                        .padding(.top, 100)
                                        .shadow(radius: 10, y: 10)
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                    HStack {
                        
                        Spacer()

    //                    NavigationLink(destination: ProfileView()) {
                            VStack{
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 25, height: 25)// Example icon
                                Text("Home")
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)

                            }
    //                    }

                            
                        
                        Spacer()
                        
                        NavigationLink(destination: InboxView()) {
                            VStack{
                                Image(systemName: "tray.full")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 25, height: 25)// Example icon
                                Text("Inbox")
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)

                            }
                        }

                            
                        
                        Spacer()
                        

                        NavigationLink(destination: CampsView()) {
                            VStack{
                                Image(systemName: "mappin.and.ellipse")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 25, height: 25)// Example icon
                                Text("Camps")
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)

                            }
                        }

                            
            //            }
                        
                        Spacer()
                        
                        NavigationLink(destination: ResourcesView()) {

                            VStack{
                                Image(systemName: "basketball")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(width: 25, height: 25)// Example icon
                                Text("Resources")
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                            }
                            
                        }

                        Spacer()

                    }
                    .padding(.top)
                    .background(Color.white)
                    
//                    // Bottom Menu
//                    FooterMenu()
//                        .zIndex(1) // Same higher zIndex for the footer
                    
                }
//                .onAppear {
//                    requestNotificationAuthorization()
//                }

                
                // Sliding menu
                if isMenuOpen {
                    MenuView(isMenuOpen: $isMenuOpen)
                        .frame(width: UIScreen.main.bounds.width)
                        .transition(.move(edge: .leading))
                        .zIndex(2) // Highest zIndex for the sliding menu
                }
                
            }

        }
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

#Preview {
    HomeView()
}
