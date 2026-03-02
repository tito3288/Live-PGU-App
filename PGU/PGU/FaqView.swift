//
//  FaqView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/29/23.
//

import SwiftUI

struct FaqView: View {
    
    @State private var expanded1: Bool = false
    @State private var expanded2: Bool = false
    @State private var expanded3: Bool = false
    @State private var expanded4: Bool = false
    @State private var expanded5: Bool = false
    @State private var expanded6: Bool = false
    @State private var expanded7: Bool = false
    @State private var expanded8: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "0f2d53").edgesIgnoringSafeArea(.all)
            
            
            VStack{
                Text("FAQ")
                    .font(.largeTitle) // You can customize the font as needed
                    .foregroundColor(.white)
                    .padding(.top)
            List {
                Group {
                    VStack{
                        HStack{
                            //                        Spacer()
                            Text("Are your camps only for Point Guards?").font(.title2).padding().fontWeight(.bold)
                            Spacer()
                            
                            Button(action: {
                                    self.expanded1.toggle()
                            }) {
                                Image(systemName: "chevron.down") // Your button text
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)
                        }
                        .listRowBackground(Color(hex: "0f2d53"))
                        .listRowInsets(EdgeInsets())
                        
                        if expanded1 {
                            Text("No! We work with all positions at every camp and every training session.")
                                .padding()
                                .animation(.easeInOut(duration: 0.5), value: expanded1)

                        }
                    }
                    
                    
                    VStack{
                        HStack{
                            //                        Spacer()
                            Text("How will we know where to go when we arrive?").font(.title2).padding().fontWeight(.bold)
                            Spacer()
                            
                            Button(action: {
                                self.expanded2.toggle()
                            }) {
                                Image(systemName: "chevron.down") // Your button text
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)
                        }
                        .listRowBackground(Color(hex: "0f2d53"))
                        .listRowInsets(EdgeInsets())
                        
                        if expanded2 {
                            Text("There will be plenty of signage in the parking lot and within the facility directing you where to check in. You will also receive an email ahead of camp with all of the information you'll need.")
                                .padding()
                                .transition(.slide)
                        }
                    }
                    
                    VStack{
                        HStack{
                            //                        Spacer()
                            Text("Are there options to stay overnight?").font(.title2).padding().fontWeight(.bold)
                            Spacer()
                            
                            Button(action: {
                                self.expanded3.toggle()
                            }) {
                                Image(systemName: "chevron.down") // Your button text
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)
                        }
                        .listRowBackground(Color(hex: "0f2d53"))
                        .listRowInsets(EdgeInsets())
                        
                        if expanded3 {
                            Text("While we are not an overnight camp and do not offer lodging, we do sometimes partner with hotels that will have special rates. If this is the case for your camp, we will let you know via email and on social media..")
                                .padding()
                                .transition(.slide)
                        }
                    }
                    
                    VStack{
                        HStack{
                            //                        Spacer()
                            Text("Do the camps consist of drills or scrimmage?").font(.title2).padding().fontWeight(.bold)
                            Spacer()
                            
                            Button(action: {
                                self.expanded4.toggle()
                            }) {
                                Image(systemName: "chevron.down") // Your button text
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)
                        }
                        .listRowBackground(Color(hex: "0f2d53"))
                        .listRowInsets(EdgeInsets())
                        
                        if expanded4 {
                            Text("For the most part, drills and stations. We want to work on an individual basis with your athlete and this allows us to do so. However, there will be time on the final day of camp for live scrimmage and fun.")
                                .padding()
                                .transition(.slide)
                        }
                    }
                    
                    VStack{
                        HStack{
                            //                        Spacer()
                            Text("How can I watch my athlete during your camps?").font(.title2).padding().fontWeight(.bold)
                            Spacer()
                            
                            Button(action: {
                                self.expanded5.toggle()
                            }) {
                                Image(systemName: "chevron.down") // Your button text
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)
                        }
                        .listRowBackground(Color(hex: "0f2d53"))
                        .listRowInsets(EdgeInsets())
                        
                        if expanded5 {
                            Text("We always have seating in the gyms, you are welcome to hang out and watch. We also broadcast every minute of camp live on Facebook. We also post daily recaps on our Instagram.")
                                .padding()
                                .transition(.slide)
                        }
                    }
                    
                    VStack{
                        HStack{
                            //                        Spacer()
                            Text("Can my athlete move up or down a group?").font(.title2).padding().fontWeight(.bold)
                            Spacer()
                            
                            Button(action: {
                                self.expanded6.toggle()
                            }) {
                                Image(systemName: "chevron.down") // Your button text
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)
                        }
                        .listRowBackground(Color(hex: "0f2d53"))
                        .listRowInsets(EdgeInsets())
                        
                        if expanded6 {
                            Text("Yep! Just shoot us an email at info@pointguarduniversity.com to let us know.")
                                .padding()
                                .transition(.slide)
                        }
                    }
                    
                    VStack{
                        HStack{
                            //                        Spacer()
                            Text("What is the refund policy?").font(.title2).padding().fontWeight(.bold)
                            Spacer()
                            
                            Button(action: {
                                self.expanded7.toggle()
                            }) {
                                Image(systemName: "chevron.down") // Your button text
                                    .frame(alignment: .trailing)
                                    .padding(10)
                                    .background(Color(hex: "c7972b"))
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                            }
                            .padding(10)
                        }
                        .listRowBackground(Color(hex: "0f2d53"))
                        .listRowInsets(EdgeInsets())
                        
                        if expanded7 {
                            Text("Full refunds are available up to seven (7) days after initial registration. No refunds will be available after May 26, 2024, regardless of when you registered. This is due to facilities, coaches, materials and travel arrangements being paid for by this time. If there is an injury or illness, there are potential options for rolling over your registration to another camp or giving your registration to another would-be camper. Refunds will be given due to injury or illness with a doctors note.")
                                .padding()
                                .transition(.slide)
                        }
                    }
                
                }
                .frame(maxWidth: .infinity, alignment: .center) // Center text in each row
                .background(Color.white)
                .cornerRadius(25)
                .listRowInsets(EdgeInsets())
                .padding(.horizontal)
                .padding(.bottom)
                .listRowBackground(Color.clear)
                
            }
            .listStyle(PlainListStyle())
            .padding(.top, 30)
            .background(Color(hex: "0f2d53"))
            .edgesIgnoringSafeArea(.all) // Ignore safe areas to extend to the top and bottom of the screen
            }
        }

    }
}

#Preview {
    FaqView()
}
