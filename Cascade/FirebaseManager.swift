//
//  FirebaseManager.swift
//  Cascade
//
//  Created by Kari Groszewska on 2/8/25.
//

import Firebase
import FirebaseAuth
import SwiftUI

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    @Published var errorMessage = ""
    
    init() {
        FirebaseApp.configure()
        
        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // Ensure UI updates happen on the main thread
            DispatchQueue.main.async {
                withAnimation {
                    self?.isLoggedIn = user != nil
                    self?.currentUser = user
                }
            }
        }
    }
    
    @MainActor
    func signUp(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            withAnimation {
                self.currentUser = result.user
                self.isLoggedIn = true
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            withAnimation {
                self.currentUser = result.user
                self.isLoggedIn = true
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            withAnimation {
                self.currentUser = nil
                self.isLoggedIn = false
            }
        } catch {
            throw error
        }
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
} 