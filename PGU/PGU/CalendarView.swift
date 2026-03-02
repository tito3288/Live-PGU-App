//
//  CalendarView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI


struct CalendarView: View {
    
    @State private var isMenuOpen: Bool = false

    
    @State private var currentPageIndex = 0
    @State private var currentPage = 0


    
    var body: some View {
        

        ZStack{
            VStack{
                //THE HAMBURGER MENU NEEDS TO BE AFTER THE VSTACK IN ORDER FOR THE MENU VIEW TO COVER THE ENTIRE VIEW WHEN THE HAMBURGER MENU GETS CLICKED ⬇️
                HamburgerMenu(isMenuOpen: $isMenuOpen)
                    .navigationBarBackButtonHidden(true)
                    .frame(height: 50)
                    .padding(.bottom, 30)
                
                Spacer()
                
                
                HStack {
                    NavigationLink(destination: CampsView()) {
                        Text("Find Camp")
                            .padding(10)
                            .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                            .background(Color(hex: "0f2d53"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    Spacer() // Spacing between buttons
                    
                        Text("Calendar")
                            .padding(10)
                            .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                            .background(Color(hex: "c7972b"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    
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
                
//                TabView(selection: $currentPageIndex) {
//                    ForEach(0..<4, id: \.self) { index in
//                        Image("Calendar-\(index + 1)")
//                            .resizable()
//                            .scaledToFit()
//                            .tag(index)
//                    }
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                .frame(height: 300)
//
//                // Custom page indicators
//                HStack(spacing: 10) {
//                    ForEach(0..<4, id: \.self) { index in
//                        Circle()
//                            .fill(currentPageIndex == index ? Color(hex: "c7972b") : Color(hex: "0f2d53"))
//                            .frame(width: 8, height: 8)
//                    }
//                }
//                .padding(.top, 10)
                
                
                

//                TabView(selection: $currentPageIndex) {
//                    ForEach(0..<3, id: \.self) { monthIndex in
//                        Image("Calendar")
//                            .resizable()
//                            .scaledToFit()
//                            .padding(.bottom, 22)
//                            .tag(monthIndex) // Ensure this tag matches the index
//                    }
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
//                .frame(height: 350)

                
                
//                MultiDatePicker("Calendar", selection: $selectedDates)
                
                
                
                
                

                List{
                    HStack{
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Dodge City, KS")
                                .font(.title2) // Style for regular text


                            Text("June 2nd- 5th, 2025")
                                .font(.body) // Style for title text

                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                currentPageIndex = 0 // Adjust this index based on the tapped item
                            }
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
                            withAnimation(.easeInOut) {
                                currentPageIndex = 1 // Adjust this index based on the tapped item
                            }
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
                            withAnimation(.easeInOut) {
                                currentPageIndex = 1 // Adjust this index based on the tapped item
                            }
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
                            withAnimation(.easeInOut) {
                                currentPageIndex = 1 // Adjust this index based on the tapped item
                            }
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
                    
                    
//                    HStack{
//                        VStack(alignment: .leading, spacing: 0) {
//                            Text("Grand Rapids, MI")
//                                .font(.title2) // Style for regular text
//
//
//                            Text("June 17th- June 20th, 2024")
//                                .font(.body) // Style for title text
//                        }
//                        .onTapGesture {
//                            withAnimation(.easeInOut) {
//                                currentPageIndex = 1 // Adjust this index based on the tapped item
//                            }
//                        }
//                        
//                        Spacer()
//                        
//                        Button(action: {
//                            DispatchQueue.main.async {
//                                if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?season=3455345&session=62024837") {
//                                    // This checks if the URL can be opened and then opens it
//                                    if UIApplication.shared.canOpenURL(url) {
//                                        UIApplication.shared.open(url)
//                                    }
//                                }
//                            }
//                        }){
//                            Text("Sign Up")
//                                .frame(alignment: .trailing)
//                                .padding(10)
//                                .background(Color(hex: "c7972b"))
//                                .foregroundColor(.white)
//                                .cornerRadius(20)
//                        }
//                    }
                    
//                    HStack{
//                        VStack(alignment: .leading, spacing: 0) {
//                            Text("Lafayette, IN")
//                                .font(.title2) // Style for regular text
//
//
//                            Text("June 24th- June 27th, 2024")
//                                .font(.body) // Style for title text
//                        }
//                        .onTapGesture {
//                            withAnimation(.easeInOut) {
//                                currentPageIndex = 1 // Adjust this index based on the tapped item
//                            }
//                        }
//                        
//                        Spacer()
//                        
//                        Button(action: {
//                            DispatchQueue.main.async {
//                                if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?season=3455345&session=62024937") {
//                                    // This checks if the URL can be opened and then opens it
//                                    if UIApplication.shared.canOpenURL(url) {
//                                        UIApplication.shared.open(url)
//                                    }
//                                }
//                            }
//                        }){
//                            Text("Sign Up")
//                                .frame(alignment: .trailing)
//                                .padding(10)
//                                .background(Color(hex: "c7972b"))
//                                .foregroundColor(.white)
//                                .cornerRadius(20)
//                        }
//                    }
                    
                    HStack{
                        VStack(alignment: .leading, spacing: 0) {
                            Text("South Bend, IN")
                                .font(.title2) // Style for regular text


                            Text("July 7th- July 10th, 2025")
                                .font(.body) // Style for title text
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                currentPageIndex = 2 // Adjust this index based on the tapped item
                            }
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
                    
                    
//                    HStack{
//                        VStack(alignment: .leading, spacing: 0) {
//                            Text("Indianapolis, IN")
//                                .font(.title2) // Style for regular text
//
//
//                            Text("June 15th- June 18th, 2024")
//                                .font(.body) // Style for title text
//                        }
//                        .onTapGesture {
//                            withAnimation(.easeInOut) {
//                                currentPageIndex = 2 // Adjust this index based on the tapped item
//                            }
//                        }
//                        
//                        Spacer()
//                        
//                        Button(action: {
//                            DispatchQueue.main.async {
//                                if let url = URL(string: "https://campscui.active.com/orgs/PointGuardU?season=3455345&session=62025237") {
//                                    // This checks if the URL can be opened and then opens it
//                                    if UIApplication.shared.canOpenURL(url) {
//                                        UIApplication.shared.open(url)
//                                    }
//                                }
//                            }
//                        }){
//                            Text("Sign Up")
//                                .frame(alignment: .trailing)
//                                .padding(10)
//                                .background(Color(hex: "c7972b"))
//                                .foregroundColor(.white)
//                                .cornerRadius(20)
//                        }
//                    }
                    
                    HStack{
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Hornell, NY")
                                .font(.title2) // Style for regular text


                            Text("July 17th- July 18th, 2025")
                                .font(.body) // Style for title text
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                currentPageIndex = 2 // Adjust this index based on the tapped item
                            }
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
 

                            Text("July 14th- 15th, 2025")
                                .font(.body) // Style for title text
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                currentPageIndex = 2 // Adjust this index based on the tapped item
                            }
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
                
                FooterMenu()

            }
            if isMenuOpen {
                MenuView(isMenuOpen: $isMenuOpen, activePage: .calendar)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(1) // Ensure the menu is on top
            }
        }
        .navigationBarBackButtonHidden(true)
        
        
    }

    private func isPredefinedDate(_ dateComponents: DateComponents) -> Bool {
        let predefinedDates: Set<DateComponents> = [
            DateComponents(year: 2024, month: 5, day: 28),
            DateComponents(year: 2024, month: 5, day: 29),
            DateComponents(year: 2024, month: 5, day: 30),
            DateComponents(year: 2024, month: 5, day: 31)
        ]
        return predefinedDates.contains(dateComponents)
    }
    
}

#Preview {
    CalendarView()
}
