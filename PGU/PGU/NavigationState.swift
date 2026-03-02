//
//  NavigationState.swift
//  PGU
//
//  Created by Bryan Arambula on 2/12/24.
//

import Foundation
import SwiftUI

class NavigationState: ObservableObject {
    static let shared = NavigationState()
    @Published var showInbox: Bool = false
    @Published var currentView: String?
}
