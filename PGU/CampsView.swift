//
//  CampsView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI
import MapKit
import CoreLocation


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
    @State private var isMenuOpen: Bool = false
    @State private var searchText = "" // State variable to hold search text
    @State private var locations = [
        Location(title: "Dodge City High School, Dodge City, KS", coordinate: CLLocationCoordinate2D(latitude: 37.78280790545586,  longitude: -100.04471873960134)),
        Location(title: "Limon Public High School, Limon, CO", coordinate: CLLocationCoordinate2D(latitude: 39.27026120527985, longitude: -103.68905270774891)),
        Location(title: "Max Jones Fieldhouse, Goodland, KS", coordinate: CLLocationCoordinate2D(latitude: 39.34647640261924 , longitude: -101.70298283866518)),
        Location(title: "Canton-Galva Jr/Sr High School, Canton, KS", coordinate: CLLocationCoordinate2D(latitude: 38.381116853763004,  longitude: -97.4329804335779)),
//        Location(title: "MSA Fieldhouse , Grand Rapids, MI", coordinate: CLLocationCoordinate2D(latitude: 42.917661227497916,  longitude: -85.53149132077283))
//        Location(title: "Legacy Courts, Lafayette, IN", coordinate: CLLocationCoordinate2D(latitude: 40.45102926168622,  longitude: -86.85728886332116))
        Location(title: "IUSB Student Activities Center, South Bend, IN", coordinate: CLLocationCoordinate2D(latitude: 41.664600041689056,  longitude: -86.2199390073205))
//        ,Location(title: "Speedway Senior High School, Indianapolis, IN", coordinate: CLLocationCoordinate2D(latitude: 39.8013165272428,  longitude: -86.25315916415522))
//        39.8013165272428, -86.25315916415522
        ,Location(title: "Hornell Senior High School, Hornell, NY", coordinate: CLLocationCoordinate2D(latitude: 42.33385628960623,  longitude: -77.66308146371362))
        ,Location(title: "Victor Primary School, Rochester, NY", coordinate: CLLocationCoordinate2D(latitude: 42.98995921819088,  longitude: -77.41404497411837))
        
    ]
    
    
    @StateObject private var locationManager = LocationManager()
    @State private var regions = MKCoordinateRegion()

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.50, longitude: -98.35), // Geographic center of the contiguous US
        span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
    )
    
    
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack { // Root view
                VStack {
                    HamburgerMenu(isMenuOpen: $isMenuOpen)
                        .navigationBarBackButtonHidden(true)
                        .frame(height: 50)
                        .padding(.bottom, 30)
                    
                    HStack {
                        
                        Text("Find Camps")
                            .padding(10)
                            .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                            .background(Color(hex: "c7972b"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Spacer() // Spacing between buttons
                        
                        NavigationLink(destination: CalendarView()) {
                            Text("Calendar")
                                .padding(10)
                                .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                                .background(Color(hex: "0f2d53"))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        Spacer() // Spacing between buttons
                        
                        NavigationLink(destination: CampInfoView()) {
                            Text("Camp Info")
                                .padding(10)
                                .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                                .background(Color(hex: "0f2d53"))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .padding()
                    
                    
                    
                    ZStack {
                        Map(coordinateRegion: $region, annotationItems: locations + (locationManager.userLocation != nil ? [locationManager.userLocation!] : [])) { location in
                            MapAnnotation(coordinate: location.coordinate) {
                                if location.isUserLocation {
                                    UserLocationView() // Custom view for user's location
                                } else {
                                    // Your existing button for other locations
                                    Button(action: {
                                        openMapForDirections(to: location)
                                    }) {
                                        VStack {
                                            Text(location.title)
                                                .font(.caption)
                                                .padding(5)
                                                .background(Color.white)
                                                .foregroundColor(Color(hex: "c7972b"))
                                                .cornerRadius(10)
                                                .shadow(radius: 3)
                                            Image(systemName: "mappin.circle.fill")
                                                .foregroundColor(Color(hex: "c7972b"))
                                                .imageScale(.medium)
                                                .background(Color(hex: "0f2d53"))
                                                .cornerRadius(20)
                                        }
                                    }
                                }
                            }
                        }
                        //                    .onAppear {
                        //                        locationManager.requestLocation()
                        //                    }
                        .onChange(of: locationManager.lastLocation) { newValue in
                            if let newLocation = newValue {
                                regions = MKCoordinateRegion(center: newLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                            }
                        }
                        //                    .mapStyle(.standard)
                        .frame(width: geometry.size.width, height: geometry.size.height >= 1300 ? 450 : 250)

                        VStack {
                            Spacer() // Pushes the button to the bottom
                            HStack {
                                Spacer() // Pushes the button to the right
                                Button(action: zoomToUserLocation) {
                                    Image(systemName: "location.fill")
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Circle().fill(Color(hex: "c7972b")))
                                        .shadow(radius: 3)
                                }
                                .padding() // Adds some space around the button
                            }
                        }
                    }
                    
                    
                    
                    Text("FIND A CAMP NEAR YOU")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(Color(hex: "0f2d53"))
                    
                    
                    
                    HStack{
                        
                        TextField("Zip Code", text: $searchText)
                            .padding(7)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.leading)
                        //                        .padding(.horizontal)
                        
                        Button(action:{
                            findNearestLocation()
                            
                        }){
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(hex: "0f2d53"))
                        }
                        .padding(7)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.trailing)
                        
                    }
                    
                    
                    List{
                        HStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Dodge City, KS")
                                    .font(.title2) // Style for regular text
                                
                                Text("June 2nd- 5th, 2025")
                                    .font(.body) // Style for title text
                            }
                            .onTapGesture {
                                zoomToLocation(Location(title: "Dodge City High School, Dodge City, KS", coordinate: CLLocationCoordinate2D(latitude: 37.78280790545586, longitude: -100.04471873960134)))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.main.async {
                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344") {
                                        // This checks if the URL can be opened and then opens it
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }){
                                Text("Sign Up")
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            
                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Limon, CO")
                                    .font(.title2) // Style for regular text
                                
                                Text("June 9th- 12th, 2025")
                                    .font(.body) // Style for title text
                            }
                            .onTapGesture {
                                zoomToLocation(Location(title: "Limon Public High School, Limon, CO", coordinate: CLLocationCoordinate2D(latitude: 39.27026120527985, longitude: -103.68905270774891)))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.main.async {
                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344") {
                                        // This checks if the URL can be opened and then opens it
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }){
                                Text("Sign Up")
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            
                        }
                        
                        
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Goodland, KS")
                                    .font(.title2) // Style for regular text
                                
                                Text("June 16th- 19th, 2025")
                                    .font(.body) // Style for title text
                            }
                            .onTapGesture {
                                zoomToLocation(Location(title: "Max Jones Fieldhouse, Goodland, KS", coordinate: CLLocationCoordinate2D(latitude: 39.34647640261924 , longitude: -101.70298283866518)))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.main.async {
                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344") {
                                        // This checks if the URL can be opened and then opens it
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }){
                                Text("Sign Up")
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            
                        }
                        
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Canton, KS")
                                    .font(.title2) // Style for regular text
                                
                                Text("July 7th- 10th, 2025")
                                    .font(.body) // Style for title text
                            }
                            .onTapGesture {
                                zoomToLocation(Location(title: "Canton-Galva Jr/Sr High School, Canton, KS", coordinate: CLLocationCoordinate2D(latitude: 38.381116853763004,  longitude: -97.4329804335779)))
                                
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.main.async {
                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344") {
                                        // This checks if the URL can be opened and then opens it
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }){
                                Text("Sign Up")
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                        
                        
//                        HStack{
//                            VStack(alignment: .leading, spacing: 0) {
//                                Text("Grand Rapids, MI")
//                                    .font(.title2) // Style for regular text
//                                
//                                Text("June 17th- June 20th, 2024")
//                                    .font(.body) // Style for title text
//                            }
//                            .onTapGesture {
//                                zoomToLocation(Location(title: "MSA Fieldhouse , Grand Rapids, MI", coordinate: CLLocationCoordinate2D(latitude: 42.917661227497916,  longitude: -85.53149132077283)))
//                            }
//                            
//                            Spacer()
//                            
//                            Button(action: {
//                                DispatchQueue.main.async {
//                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?season=3455345&session=62024837") {
//                                        // This checks if the URL can be opened and then opens it
//                                        if UIApplication.shared.canOpenURL(url) {
//                                            UIApplication.shared.open(url)
//                                        }
//                                    }
//                                }
//                            }){
//                                Text("Sign Up")
//                                    .frame(alignment: .trailing)
//                                    .padding(10)
//                                    .background(Color(hex: "c7972b"))
//                                    .foregroundColor(.white)
//                                    .cornerRadius(20)
//                            }
//                        }
                        
                        
//                        HStack{
//                            VStack(alignment: .leading, spacing: 0) {
//                                Text("Lafayette, IN")
//                                    .font(.title2) // Style for regular text
//                                
//                                Text("June 24th- June 27th, 2024")
//                                    .font(.body) // Style for title text
//                            }
//                            .onTapGesture {
//                                zoomToLocation(Location(title: "Legacy Courts, Lafayette, IN", coordinate: CLLocationCoordinate2D(latitude: 40.45102926168622,  longitude: -86.85728886332116)))
//                            }
//                            
//                            Spacer()
//                            
//                            Button(action: {
//                                DispatchQueue.main.async {
//                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?season=3455345&session=62024937") {
//                                        // This checks if the URL can be opened and then opens it
//                                        if UIApplication.shared.canOpenURL(url) {
//                                            UIApplication.shared.open(url)
//                                        }
//                                    }
//                                }
//                            }){
//                                Text("Sign Up")
//                                    .frame(alignment: .trailing)
//                                    .padding(10)
//                                    .background(Color(hex: "c7972b"))
//                                    .foregroundColor(.white)
//                                    .cornerRadius(20)
//                            }
//                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Text("South Bend, IN")
                                    .font(.title2) // Style for regular text
                                Text("July 7th- 10th, 2025")
                                    .font(.body) // Style for title text
                            }
                            .onTapGesture {
                                zoomToLocation(Location(title: "IUSB Student Activities Center, South Bend, IN", coordinate: CLLocationCoordinate2D(latitude: 41.664600041689056,  longitude: -86.2199390073205)))
                            }
                            
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.main.async {
                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344") {
                                        // This checks if the URL can be opened and then opens it
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }){
                                Text("Sign Up")
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                        
//                        HStack{
//                            VStack(alignment: .leading, spacing: 0) {
//                                Text("Indianapolis, IN")
//                                    .font(.title2) // Style for regular text
//                                
//                                Text("July 15th- July 18th, 2024")
//                                    .font(.body) // Style for title text
//                            }
//                            .onTapGesture {
//                                zoomToLocation(Location(title: "Speedway Senior High School, Indianapolis, IN", coordinate: CLLocationCoordinate2D(latitude: 39.8013165272428,  longitude: -86.25315916415522)))
//                            }
//                            
//                            Spacer()
//                            
//                            Button(action: {
//                                DispatchQueue.main.async {
//                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?season=3455345&session=62025237") {
//                                        // This checks if the URL can be opened and then opens it
//                                        if UIApplication.shared.canOpenURL(url) {
//                                            UIApplication.shared.open(url)
//                                        }
//                                    }
//                                }
//                            }){
//                                Text("Sign Up")
//                                    .frame(alignment: .trailing)
//                                    .padding(10)
//                                    .background(Color(hex: "c7972b"))
//                                    .foregroundColor(.white)
//                                    .cornerRadius(20)
//                            }
//                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Hornell, NY")
                                    .font(.title2) // Style for regular text
                                
                                Text("July 17th- 18th, 2025")
                                    .font(.body) // Style for title text
                            }
                            .onTapGesture {
                                zoomToLocation(Location(title: "Hornell Senior High School, Hornell, NY", coordinate: CLLocationCoordinate2D(latitude: 42.33385628960623,  longitude: -77.66308146371362)))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.main.async {
                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344") {
                                        // This checks if the URL can be opened and then opens it
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }){
                                Text("Sign Up")
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Rochester, NY")
                                    .font(.title2) // Style for regular text
                                
                                Text("July 14- 15th, 2025")
                                    .font(.body) // Style for title text
                            }
                            .onTapGesture {
                                zoomToLocation(Location(title: "Victor Primary School, Rochester, NY", coordinate: CLLocationCoordinate2D(latitude: 42.99009263438155,  longitude: -77.41409861198184)))
                            }
                            
                            
                            Spacer()
                            
                            Button(action: {
                                DispatchQueue.main.async {
                                    if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?orglink=camps-registration#/selectSessions/3571344") {
                                        // This checks if the URL can be opened and then opens it
                                        if UIApplication.shared.canOpenURL(url) {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                                }
                            }){
                                Text("Sign Up")
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                        }
                        
                    }
                    .listStyle(PlainListStyle()) // Removes extra padding and separators in iOS 14+
                    
                    
                    
                    //                FooterMenu()
                    
                    Divider()
                    
                    HStack {
                        
                        Spacer()
                        
                        NavigationLink(destination: HomeView()) {
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
                        }
                        
                        
                        
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
                        
                        //                    NavigationLink(destination: CampsView()) {
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
                        //                    }
                        
                        
                        
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
                    
                    
                }
                
                // Sliding menu
                if isMenuOpen {
                    MenuView(isMenuOpen: $isMenuOpen)
                        .frame(width: UIScreen.main.bounds.width)
                        .transition(.move(edge: .leading))
                        .zIndex(1) // Ensure the menu is on top
                }
            }
        }
    }
    
    private func findNearestLocation() {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(searchText) { (placemarks, error) in
            if let error = error {
                // Handle the error here (e.g., user entered an invalid zip code)
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first, let location = placemark.location {
                self.updateMapToNearestLocation(userLocation: location)
                searchText = ""
            }
        }
    }
    
    private func zoomToLocation(_ location: Location) {
        withAnimation(.easeInOut) {
            region.center = location.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) // Adjust zoom level as needed
        }
    }
    
    private func zoomToUserLocation() {
        if let userLocation = locationManager.lastLocation {
            print("Zooming to user location: \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
            withAnimation {
                region = MKCoordinateRegion(
                    center: userLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
            }
        } else {
            print("User location not available")
        }
    }

    
    
    private func updateMapToNearestLocation(userLocation: CLLocation) {
        var nearestLocation: Location? = nil
        var smallestDistance: CLLocationDistance?
        
        for location in locations {
            let locationCoordinates = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let distance = userLocation.distance(from: locationCoordinates)
            
            if smallestDistance == nil || distance < smallestDistance! {
                smallestDistance = distance
                nearestLocation = location
            }
        }
        
        if let nearestLocation = nearestLocation {
            withAnimation(.easeInOut(duration: 1.5)) {
                region.center = nearestLocation.coordinate
                region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Adjust the zoom level as needed
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

}


#Preview {
    CampsView()
}
