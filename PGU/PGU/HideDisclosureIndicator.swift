//
//  HideDisclosureIndicator.swift
//  PGU
//
//  Created by Bryan Arambula on 12/27/23.
//

import SwiftUI

struct HideDisclosureIndicator: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Image(systemName: "chevron.right")
                .opacity(0) // Make the chevron transparent
        }
    }
}

extension View {
    func hideDisclosureIndicator() -> some View {
        self.modifier(HideDisclosureIndicator())
    }
}
