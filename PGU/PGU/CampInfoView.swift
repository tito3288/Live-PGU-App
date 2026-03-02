//
//  CampInfoView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI

struct CampInfoView: View {
    
    
    @State private var isMenuOpen: Bool = false


    
    var body: some View {
     
        ZStack{
            VStack{
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

                    NavigationLink(destination: CalendarView()) {
                        Text("Calendar")
                            .padding(10)
                            .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                            .background(Color(hex: "0f2d53"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }

                    Spacer() // Spacing between buttons

                    Text("Camp Info")
                        .padding(10)
                        .frame(minWidth: 0, maxWidth: .infinity) // Flexible frame
                        .background(Color(hex: "c7972b"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()

                
                
                
                ScrollView{
                    
                    Text("Cost")
                        .font(.title)
                        .padding(.bottom)
                        .padding(.top)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Early Bird: $150")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Normal Rate: $175")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text("Duration")
                        .font(.title)
                        .padding(.bottom)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Monday-Thursday | 3 Sessions: 8 AM -11 AM, 12 PM - 3 PM, 4 PM - 7 PM")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                    Text("Learn from the best, teaching their best.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Each day, we welcome a new set of top coaches from the area to camp to run a station showcasing their best drills.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                    
                    Text("Each camper will receive a t-shirt. We will be capping this camp at 225 athletes. Spots are given on a first come, first serve basis. After 225 registrations, we will start a Waiting List.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)

                    Text("HOW WE'RE DIFFERENT")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Image("logo3")
                        .resizable()
                        .frame(width: 312, height: 212)
                        .padding()

                    Text("We don't throw the ball up and scrimmage.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("We create relationships. We make sure your athlete leaves with drills and a plan to become a better player. We make sure your athlete stays involved, has fun and create lifelong memories.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("We cap the number of athletes that can attend each camp for a reason. We make sure everyone gets individual attention and instruction.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("We take this seriously. Just like a real game, we have a gameplan every week, every day and every hour. We don't leave anything to chance, there is intention behind each decision.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("OUR IMPACT")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("We have welcomed over 5,000 campers since 2017.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("With the help of our sponsors this year, we will welcome over 200 athletes to camps and clinics that otherwise would not have been able to afford it.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("This year, we will hold free clinics in every state we attend on our tour.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    
                    Text("This year, we will give back thousands of dollars to local communities, local athletic departments and local athletic clubs.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)

               
                }
                .padding(.trailing)
                .padding(.leading)
    
                FooterMenu()
            }
            
            if isMenuOpen {
                MenuView(isMenuOpen: $isMenuOpen, activePage: .campInfo)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(1) // Ensure the menu is on top
            }
        }
        

    }
    
    
}

#Preview {
    CampInfoView()
}
