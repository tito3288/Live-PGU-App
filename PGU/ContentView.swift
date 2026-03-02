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
    @EnvironmentObject var navigationState: NavigationState

    var body: some View {
        if authViewModel.isAuthenticated {
            TabView(selection: $navigationState.selectedTab) {
                Tab("Home", systemImage: "house.fill", value: .home) {
                    NavigationStack {
                        HomeView()
                    }
                }
                Tab("Inbox", systemImage: "tray.fill", value: .inbox) {
                    NavigationStack {
                        InboxView()
                    }
                }
                Tab("Camps", systemImage: "mappin.and.ellipse", value: .camps) {
                    NavigationStack {
                        CampsView()
                    }
                }
                Tab("Resources", systemImage: "basketball.fill", value: .resources) {
                    NavigationStack {
                        FilmReviewView()
                    }
                }
            }
            .tint(Color(hex: "c7972b"))
        } else {
            NavigationStack {
                LoginView()
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    ContentView()
}
