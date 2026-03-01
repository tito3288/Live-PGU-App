//
//  ContentView.swift
//  PGU
//
//  Created by Bryan Arambula on 11/21/23.
//

import SwiftUI
import FirebaseAuth
import AppTrackingTransparency
import AdSupport

struct ContentView: View {
    @StateObject var authViewModel = AuthenticationViewModel()
    @EnvironmentObject var navigationState: NavigationState  // Add this line


    var body: some View {
        
        NavigationView {
            if authViewModel.isAuthenticated {
                if navigationState.showInbox {  // Check if should navigate to Inbox
                    InboxView()
                        .navigationBarHidden(true)
                } else {
                    HomeView()
                        .navigationBarHidden(true)
                }
            } else {
                LoginView()
                    .navigationBarHidden(true)
            }
        }
//        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                requestPermission()
//            }
//        }
        .accentColor(Color(hex: "c7972b"))
        .navigationViewStyle(StackNavigationViewStyle())



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

}

#Preview {
    ContentView()

}
