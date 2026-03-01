//
//  File.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI



struct FooterMenu: View {

    
//    @Environment(\.managedObjectContext) var viewContext


    var body: some View {
 
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
            
//            Button(action: {
//                // Action for the third icon
//            }) {
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
 
    }

    
}

