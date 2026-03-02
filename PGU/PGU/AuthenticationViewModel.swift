//
//  AuthenticationViewModel.swift
//  PGU
//
//  Created by Bryan Arambula on 1/14/24.
//

import SwiftUI
import FirebaseAuth

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false

    init() {
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.isAuthenticated = user != nil
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

