//
//  HamburgerMenu.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

//
//  File.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI

struct HamburgerMenu: View {
    
    @Binding var isMenuOpen: Bool
    
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation {
                        isMenuOpen.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .font(.largeTitle) // Adjusts the size of the icon
                        .foregroundColor(.primary) // Sets the color to the primary text color
                }
                .frame(width: 40) // Set the width of the button
                .padding(.top)
                .padding()
                
                Spacer()
                
                Image("logo").resizable().scaledToFit()
                    .padding(.top)
                
                Spacer()
                
                // Invisible spacer with the same width as the button
                Spacer()
                    .frame(width: 80)
            }
          
        }
        .background(Color.white)
        
        
    }
}

