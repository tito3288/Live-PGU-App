//
//  ContactView.swift
//  PGU
//
//  Created by Bryan Arambula on 1/22/24.
//

import SwiftUI
import CoreLocation

struct ContactView: View {
    
    @State private var isMenuOpen: Bool = false


    var body: some View {
        ZStack {

            VStack {
                HamburgerMenu(isMenuOpen: $isMenuOpen)
                    .navigationBarBackButtonHidden(true)
                    .frame(height: 50)
                    .padding(.bottom, 5)

//                Spacer() // This spacer pushes the footer to the bottom
                
                VStack{
                    Image(systemName: "phone.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .padding(.top, 50)
                        .foregroundColor(Color(hex: "0f2d53"))
                    
                    Button(action: {
                        callPhoneNumber()
                    }) {
                        Text("574-208-3941")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .underline()
                    }

                    
                }
                .padding(.leading)

                    
                    Spacer()
                    
                VStack{
                    Image(systemName: "envelope.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .foregroundColor(Color(hex: "0f2d53"))

                    
                    Text("info@pointguarduniversity.com")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .underline()
                    
                    
                }
                .padding(.leading)
                .padding(.top)


                Spacer()
                    
                    
                VStack{
                    Image(systemName: "mappin.and.ellipse.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                        .foregroundColor(Color(hex: "0f2d53"))

                    
                    Button(action: {
                        openMapForAddress()
                    }) {
                        VStack{
                            Text("201 W Monroe St")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .underline()
                            
                            Text("South Bend, Indiana 46601")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading)
                                .underline()
                        }

                    }
                    
                    
                }
                .padding(.leading)
                .padding(.top)

                Spacer()
                
                Image("pgu")
                    .resizable()
                    .scaledToFit()
//                    .padding(.top)
                    
                
                Spacer()

                
                FooterMenu()
//                    .padding(.bottom, 40)
                    .zIndex(1) // Same higher zIndex for the footer
            }

            // Side menu
            if isMenuOpen {
                MenuView(isMenuOpen: $isMenuOpen)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(2) // Even higher zIndex to ensure it's above everything else
            }
        }
    }
    
    func openMapForAddress() {
        let address = "201 W Monroe St, South Bend, Indiana, 46601"
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("No location found")
                return
            }
            // Directions to the location
            let destinationCoordinates = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            let path = "http://maps.apple.com/?daddr=\(destinationCoordinates)&dirflg=d"
            if let url = URL(string: path) {
                UIApplication.shared.open(url)
            }
        }
    }

    
    func callPhoneNumber() {
        if let url = URL(string: "tel://5742083941"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}


#Preview {
    ContactView()
}
