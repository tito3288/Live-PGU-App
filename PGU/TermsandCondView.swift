//
//  TermsandCondView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/29/23.
//

import SwiftUI

struct TermsandCondView: View {
    
    @State private var isMenuOpen: Bool = false

    
    let bulletPoints = [
        "publishing any Website material in any other media;",
        "selling, sublicensing and/or otherwise commercializing any Website material;",
        "publicly performing and/or showing any Website material;",
        "using this Website in any way that is or may be damaging to this Website;",
        "using this Website in any way that impacts user access to this Website;",
        "using this Website contrary to applicable laws and regulations, or in any way may cause harm to the Website, or to any person or business entity;",
        "engaging in any data mining, data harvesting, data extracting or any other similar activity in relation to this Website;",
        "using this Website to engage in any advertising or marketing."
     ]
    
    
    var body: some View {
        ZStack{
            VStack{
//                HamburgerMenu(isMenuOpen: $isMenuOpen)
//                    .navigationBarBackButtonHidden(true)
//                    .frame(height: 50)
//                    .padding(.bottom, 30)
                


                
//                Spacer()
                
                
                ScrollView{
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 90)
                        .padding(.top)
                    
                    Text("TERMS AND CONDITIONS")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Text("Note")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("This page is placeholder only and is not the official PGU terms and conditions.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Introduction")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("These Website Standard Terms and Conditions written on this web page shall manage your use of our website, Website Name accessible at Website.com.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("These Terms will be applied fully and affect to your use of this Website. By using this Website, you agreed to accept all terms and conditions written in here. You must not use this Website if you disagree with any of these Website Standard Terms and Conditions.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text("Minors or people below 18 years old are not allowed to use this Website.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text("Intellectual Property Rights Other than the content you own, under these Terms, Company Name and/or its licensors own all the intellectual property rights and materials contained in this Website.")
                        .padding(.bottom)
                    
                    Text("You are granted limited license only for purposes of viewing the material contained on this Website.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text("Restrictions")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("You are specifically restricted from all of the following:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(bulletPoints, id: \.self) { point in
                            HStack(alignment: .top) {
                                Text("•")
                                    .font(.body)
                                Text(point)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)

                    
                    
                    
                    Text("Certain areas of this Website are restricted from being access by you and Company Name may further restrict access by you to any areas of this Website, at any time, in absolute discretion. Any user ID and password you may have for this Website are confidential and you must maintain confidentiality as well.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    Text("Your Content")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("In these Website Standard Terms and Conditions, “Your Content” shall mean any audio, video text, images or other material you choose to display on this Website. By displaying Your Content, you grant Company Name a non-exclusive, worldwide irrevocable, sub licensable license to use, reproduce, adapt, publish, translate and distribute it in any and all media.")
                        .padding(.bottom)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Your Content must be your own and must not be invading any third-party's rights. Company Name reserves the right to remove any of Your Content from this Website at any time without notice")
                    
                    
                }
                .padding(.trailing)
                .padding(.leading)
                
                
                Spacer()
                
                
                FooterMenu()
            }
            
            if isMenuOpen {
                MenuView(isMenuOpen: $isMenuOpen)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
            }
        }    }
}

#Preview {
    TermsandCondView()
}
