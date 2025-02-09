//
//  CascadeApp.swift
//  Cascade
//
//  Created by Kari Groszewska on 2/8/25.
//

import SwiftUI
import FirebaseCore

@main
struct CascadeApp: App {
    @StateObject private var firebaseManager = FirebaseManager.shared
    
    var body: some Scene {
        WindowGroup {
            if firebaseManager.isLoggedIn {
                HomeView()
            } else {
                LoginView()
            }
        }
    }
}
