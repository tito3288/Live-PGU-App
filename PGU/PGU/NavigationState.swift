//
//  NavigationState.swift
//  PGU
//
//  Created by Bryan Arambula on 2/12/24.
//

import Foundation
import SwiftUI

enum AppTab: String {
    case home, inbox, camps, resources
}

class NavigationState: ObservableObject {
    static let shared = NavigationState()
    @Published var selectedTab: AppTab = .home
    @Published var showInbox: Bool = false
    @Published var currentView: String?
    @Published var isMenuOpen: Bool = false
}
