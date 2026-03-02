//
//  CampsView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - Camp Data Model
struct CampData: Identifiable {
    let id = UUID()
    let city: String
    let state: String
    var displayName: String {
        "\(city), \(state)"
    }
    let dates: String
    let opens: String // e.g., "OPENS 3/23"
    let coordinate: CLLocationCoordinate2D
    let locationTitle: String // Full location name for map pin
    let registrationURL: String
}

struct Location: Identifiable {
    let id = UUID()
    var title: String
    var coordinate: CLLocationCoordinate2D
    var isUserLocation: Bool = false
}

struct UserLocationView: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .foregroundColor(.blue)
            .background(Circle().fill(Color.white))
            .shadow(radius: 3)
            .imageScale(.large)
    }
}

struct CampsView: View {
    @EnvironmentObject var navigationState: NavigationState
    @State private var searchText = ""
    
    // Updated camp locations for 2025
    @State private var camps: [CampData] = [
        CampData(
            city: "Limon",
            state: "CO",
            dates: "June 8-11",
            opens: "OPENS 3/23",
            coordinate: CLLocationCoordinate2D(latitude: 39.27026120527985, longitude: -103.68905270774891),
            locationTitle: "Limon Public High School, Limon, CO",
            registrationURL: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344"
        ),
        CampData(
            city: "Goodland",
            state: "KS",
            dates: "June 15-18",
            opens: "OPENS 3/23",
            coordinate: CLLocationCoordinate2D(latitude: 39.34647640261924, longitude: -101.70298283866518),
            locationTitle: "Max Jones Fieldhouse, Goodland, KS",
            registrationURL: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344"
        ),
        CampData(
            city: "Marion",
            state: "KS",
            dates: "June 22-25",
            opens: "OPENS 3/23",
            coordinate: CLLocationCoordinate2D(latitude: 38.34495, longitude: -97.01724),
            locationTitle: "Marion USD 408, Marion, KS",
            registrationURL: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344"
        ),
        CampData(
            city: "South Bend",
            state: "IN",
            dates: "June 29 - July 2",
            opens: "OPENS 3/23",
            coordinate: CLLocationCoordinate2D(latitude: 41.664600041689056, longitude: -86.2199390073205),
            locationTitle: "IUSB Student Activities Center, South Bend, IN",
            registrationURL: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344"
        )
    ]
    
    @State private var locations: [Location] = []
    @StateObject private var locationManager = LocationManager()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.50, longitude: -98.35),
        span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
    )
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.96, green: 0.96, blue: 0.96)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
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
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // Title Section
                        VStack(alignment: .leading, spacing: 4) {
                            Text("2026 Summer Tour")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text("Find a Camp")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text("Near You")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        
                        // Map Card with overlay
                        ZStack(alignment: .bottom) {
                            // Map
                            Map(coordinateRegion: $region, annotationItems: locations + (locationManager.userLocation != nil ? [locationManager.userLocation!] : [])) { location in
                                MapAnnotation(coordinate: location.coordinate) {
                                    if location.isUserLocation {
                                        UserLocationView()
                                    } else {
                                        Button(action: {
                                            openMapForDirections(to: location)
                                        }) {
                                            VStack(spacing: 4) {
                                                Text(location.title)
                                                    .font(.caption2)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color.white)
                                                    .foregroundColor(Color(hex: "c7972b"))
                                                    .cornerRadius(8)
                                                    .shadow(radius: 2)
                                                Image(systemName: "mappin.circle.fill")
                                                    .font(.title2)
                                                    .foregroundColor(Color(hex: "c7972b"))
                                                    .background(Circle().fill(Color.white).padding(2))
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 280)
                            .cornerRadius(20)
                            .onChange(of: locationManager.lastLocation) { newValue in
                                if let newLocation = newValue {
                                    region = MKCoordinateRegion(
                                        center: newLocation.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    )
                                }
                            }
                            
                            // Dark overlay at bottom
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, Color.black.opacity(0.7)]),
                                startPoint: .center,
                                endPoint: .bottom
                            )
                            .frame(height: 280)
                            .cornerRadius(20)
                            
                            // Overlay text
                            VStack(alignment: .leading, spacing: 8) {
                                Text("2026 Summer Tour")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("4 States • 4 Stops • Unlimited Memories")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(20)
                            
                            // Location button
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Button(action: zoomToUserLocation) {
                                        Image(systemName: "location.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                            .frame(width: 44, height: 44)
                                            .background(Circle().fill(Color(hex: "c7972b")))
                                            .shadow(radius: 4)
                                    }
                                    .padding(16)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Enter Zip Code", text: $searchText)
                                .font(.system(size: 16))
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .onSubmit {
                            findNearestLocation()
                        }
                        
                        // ALL CAMPS Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("ALL CAMPS")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(camps) { camp in
                                    CampRowCard(
                                        camp: camp,
                                        onLocationTap: {
                                            zoomToCamp(camp)
                                        },
                                        onSignUpTap: {
                                            openRegistration(camp)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // Bottom padding for tab bar
                        Color.clear
                            .frame(height: 80)
                    }
                }
                
            }
            
            // Sliding menu overlay
            if navigationState.isMenuOpen {
                MenuView(isMenuOpen: $navigationState.isMenuOpen, activePage: .camps)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
            }
        }
        .toolbar(navigationState.isMenuOpen ? .hidden : .visible, for: .tabBar)
        .onAppear {
            setupLocations()
        }
    }
    
    // MARK: - Helper Functions
    
    private func setupLocations() {
        locations = camps.map { camp in
            Location(
                title: camp.displayName,
                coordinate: camp.coordinate,
                isUserLocation: false
            )
        }
    }
    
    private func findNearestLocation() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                updateMapToNearestLocation(userLocation: location)
                searchText = ""
            }
        }
    }
    
    private func zoomToCamp(_ camp: CampData) {
        withAnimation(.easeInOut) {
            region.center = camp.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }
    }
    
    private func zoomToUserLocation() {
        if let userLocation = locationManager.lastLocation {
            withAnimation {
                region = MKCoordinateRegion(
                    center: userLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        } else {
            print("User location not available")
        }
    }
    
    private func updateMapToNearestLocation(userLocation: CLLocation) {
        var nearestCamp: CampData?
        var smallestDistance: CLLocationDistance?
        
        for camp in camps {
            let campLocation = CLLocation(latitude: camp.coordinate.latitude, longitude: camp.coordinate.longitude)
            let distance = userLocation.distance(from: campLocation)
            
            if smallestDistance == nil || distance < smallestDistance! {
                smallestDistance = distance
                nearestCamp = camp
            }
        }
        
        if let nearestCamp = nearestCamp {
            withAnimation(.easeInOut(duration: 1.5)) {
                region.center = nearestCamp.coordinate
                region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            }
        }
    }
    
    private func openMapForDirections(to location: Location) {
        let destinationCoordinate = location.coordinate
        let placemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = location.title
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    private func openRegistration(_ camp: CampData) {
        DispatchQueue.main.async {
            if let url = URL(string: camp.registrationURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
}


// MARK: - Camp Row Card Component
struct CampRowCard: View {
    let camp: CampData
    let onLocationTap: () -> Void
    let onSignUpTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Location Icon
            ZStack {
                Circle()
                    .fill(Color(hex: "c7972b").opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "c7972b"))
            }
            
            // Camp Details
            VStack(alignment: .leading, spacing: 4) {
                Text(camp.displayName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                
                Text(camp.dates)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .onTapGesture {
                onLocationTap()
            }
            
            Spacer()
            
            // Sign Up Button
            Button(action: onSignUpTap) {
                Text("Sign Up")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: "c7972b"))
                    .cornerRadius(20)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    CampsView()
}

