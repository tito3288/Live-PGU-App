//
//  MenuView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


struct MenuView: View {
 
    
    @Binding var isMenuOpen: Bool
    @State private var showingLogoutAlert = false
    @State private var navigateToLogin = false
    
    @State private var userName = "@Username"  // State variable for user's name

    @State private var navigateToHome = false
    @State private var navigateToInfo = false
    @State private var navigateToCalendar = false
    @State private var navigateToLocations = false
    @State private var navigateToResources = false
    @State private var navigateToContactUs = false


    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                Color(hex: "0f2d53").edgesIgnoringSafeArea(.all)
                
                //Figure out how the text stays in the middle of the screen. ⬇️
                
                List {
                    HStack {
                        // Your existing Text views for "Hello" and userName
                        (Text("Hello ")
                            .foregroundColor(Color.white) +
                         Text(userName)
                            .foregroundColor(Color(hex: "c7972b")))
                        .font(.title3)
                        .fontWeight(.bold)

                        Spacer() // This pushes the text to the left and the button to the right

                        // Close button
                        Button(action: {
                            // Your action here to close the menu
                            withAnimation {
                                self.isMenuOpen = false
                            }
                        }) {
                            Image(systemName: "xmark.circle.fill") // Stylish "X" mark
                                .foregroundColor(Color(hex: "c7972b")) // Set the color to match your design
                                .font(.title3) // Match the font size of your text
                        }
                    }
                    .padding(.bottom) // Keep your padding to maintain layout consistency
                    .listRowBackground(Color(hex: "0f2d53")) // Your existing background color for the row
                    // Rest of your List content...
                    
                    
                    Group {
                        
                        Button(action: {
                            self.navigateToHome = true
                        }) {
                            HStack{
                                Spacer()
                                Text("Profile").font(.title2).padding()
                                Spacer()
                            }
                        }
                        .background(NavigationLink(destination: ProfileView(), isActive: $navigateToHome) { EmptyView() }.hidden())
                        
                        
                        Button(action: {
                            self.navigateToInfo = true
                        }) {
                            HStack{
                                Spacer()
                                Text("Camp Info").font(.title2).padding()
                                Spacer()
                            }
                        }
                        .background(NavigationLink(destination: CampInfoView(), isActive: $navigateToInfo) { EmptyView() }.hidden())
                        
                        
                        Button(action: {
                            self.navigateToCalendar = true
                        }) {
                            HStack{
                                Spacer()
                                Text("Camp Calendar").font(.title2).padding()
                                Spacer()
                            }
                        }
                        .background(NavigationLink(destination: CalendarView(), isActive: $navigateToCalendar) { EmptyView() }.hidden())
                        
                        
                        Button(action: {
                            self.navigateToLocations = true
                        }) {
                            HStack{
                                Spacer()
                                Text("Camp Locations").font(.title2).padding()
                                Spacer()
                            }
                        }
                        .background(NavigationLink(destination: CampsView(), isActive: $navigateToLocations) { EmptyView() }.hidden())
                        
                        
                        Button(action: {
                            self.navigateToResources = true
                        }) {
                            HStack{
                                Spacer()
                                Text("Resources").font(.title2).padding()
                                Spacer()
                            }
                        }
                        .background(NavigationLink(destination: ResourcesView(), isActive: $navigateToResources) { EmptyView() }.hidden())
                        
                        
                        Button(action: {
                            self.navigateToContactUs = true
                        }) {
                            HStack{
                                Spacer()
                                Text("Contact Us").font(.title2).padding()
                                Spacer()
                            }
                        }
                        .background(NavigationLink(destination: ContactView(), isActive: $navigateToContactUs) { EmptyView() }.hidden())
                        
                        
                        //                    NavigationLink(destination: HomeView()) {
                        //                        HStack{
                        //                            Spacer()
                        //                            Text("Home").font(.title2).padding()
                        //                            Spacer()
                        //                        }
                        //                    }
                        //                    .listRowBackground(Color(hex: "0f2d53"))
                        //                    .listRowInsets(EdgeInsets())
                        //
                        //                    NavigationLink(destination: CampInfoView()){
                        //                        HStack{
                        //                            Spacer()
                        //                            Text("Camp Info").font(.title2).padding()
                        //                            Spacer()
                        //                        }
                        //                    }
                        //                    .listRowBackground(Color(hex: "0f2d53"))
                        //                    .listRowInsets(EdgeInsets())
                        //
                        //                    NavigationLink(destination: CalendarView()){
                        //                        HStack{
                        //                            Spacer()
                        //                            Text("Camp Calendar").font(.title2).padding()
                        //                            Spacer()
                        //                        }
                        //                    }
                        //                    .listRowBackground(Color(hex: "0f2d53"))
                        //                    .listRowInsets(EdgeInsets())
                        //
                        //                    NavigationLink(destination: CampsView()){
                        //                        HStack{
                        //                            Spacer()
                        //                            Text("Camp Locations").font(.title2).padding()
                        //                            Spacer()
                        //                        }
                        //                    }
                        //                    .listRowBackground(Color(hex: "0f2d53"))
                        //                    .listRowInsets(EdgeInsets())
                        //
                        //                    NavigationLink(destination: ResourcesView()){
                        //                        HStack{
                        //                            Spacer()
                        //                            Text("Resources").font(.title2).padding()
                        //                            Spacer()
                        //                        }
                        //                    }
                        //                    .listRowBackground(Color(hex: "0f2d53"))
                        //                    .listRowInsets(EdgeInsets())
                        //
                        //
                        //                    NavigationLink(destination: ContactView()){
                        //                        HStack{
                        //                            Spacer()
                        //                            Text("Contact Us").font(.title2).padding()
                        //                            Spacer()
                        //                        }
                        //                    }
                        //                    .listRowBackground(Color(hex: "0f2d53"))
                        //                    .listRowInsets(EdgeInsets())
                    }
                    .listRowBackground(Color(hex: "0f2d53"))
                    .listRowInsets(EdgeInsets())
                    .frame(maxWidth: .infinity, alignment: .center) // Center text in each row
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    .listRowBackground(Color.white)
                    .padding(.bottom)
                    
                    
                    
                    Button(action: {
                        self.showingLogoutAlert = true
                    }) {
                        Text("Log Out")
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.title2)
                    .padding()
                    .background(Color(hex: "c7972b"))
                    .cornerRadius(25)// Clear background for the Log Out row
                    .listRowInsets(EdgeInsets()) // Removes default padding
                    .padding(.horizontal)
                    .listRowBackground(Color(hex: "0f2d53"))
                    
                    
                    
                    Text("FOLLOW US")
                        .listRowBackground(Color(hex: "0f2d53"))
                        .foregroundColor(Color.white)
                        .font(.title3)
                        .padding(.top)
                        .fontWeight(.bold)
                    
                    
                    // Facebook Button
                    Button(action: {
                        if let url = URL(string: "https://www.facebook.com/handlethegame") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Facebook")
                        
                    }
                    .foregroundColor(Color(hex: "c7972b"))
                    .listRowBackground(Color(hex: "0f2d53"))
                    .background(Color(hex: "0f2d53")) // Set background color
                    .font(.title3) // Set font
                    
                    
                    // Instagram Button
                    Button(action: {
                        if let url = URL(string: "https://www.instagram.com/handlethegame/") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("Instagram")
                        
                    }
                    .foregroundColor(Color(hex: "c7972b"))
                    .listRowBackground(Color(hex: "0f2d53"))
                    .background(Color(hex: "0f2d53")) // Set background color
                    .font(.title3) // Set font
                    
                    // TikTok Button
                    Button(action: {
                        if let url = URL(string: "https://www.tiktok.com/@pointguardu") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("TikTok")
                        
                    }
                    .foregroundColor(Color(hex: "c7972b"))
                    .listRowBackground(Color(hex: "0f2d53"))
                    .background(Color(hex: "0f2d53")) // Set background color
                    .font(.title3) // Set font
                    .padding(.bottom)
                    
                    
                    
                    
                }
                .onAppear(perform: loadUserData)
                .listStyle(PlainListStyle())
                .padding(.top, geometry.size.height > 800 ? 130 : 85) // Adjust padding based on screen height
                .background(Color(hex: "0f2d53"))
                .edgesIgnoringSafeArea(.all)
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
            
            NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                EmptyView()
            }
            
        }
    }
    
    //MARK: LOGIC TO RETREIVE NAME FROM FIRESTORE
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





#Preview {
    MenuView(isMenuOpen: .constant(true))
}
