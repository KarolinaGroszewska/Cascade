//
//  ProfileView.swift
//  Cascade
//
//  Created by Kari Groszewska on 2/8/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var firebaseManager = FirebaseManager.shared
    @State private var showingSignOutAlert = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    // Custom colors to match app theme
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    let lightPurple = Color(red: 147/255, green: 112/255, blue: 219/255).opacity(0.6)
    
    @State private var isEditMode = false
    @State private var name = "John Doe"
    @State private var email = "john.doe@example.com"
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Profile Header
            VStack(spacing: 0) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(deeperBlue)
                
                Text(name)
                    .font(.custom("Avenir-Heavy", size: 24))
                
                Text(email)
                    .font(.custom("Avenir", size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 24)
            
            // Profile Settings
            ScrollView {
                VStack(spacing: 24) {
                    // Personal Information Section
                    ProfileSection(title: "Personal Information") {
                        ProfileButton(icon: "person.fill", title: "Edit Profile") {
                            isEditMode.toggle()
                        }
                        
                        ProfileButton(icon: "lock.fill", title: "Security Settings") {
                            // Handle security settings
                        }
                    }
                    
                    // Preferences Section
                    ProfileSection(title: "Preferences") {
                        Toggle(isOn: $notificationsEnabled) {
                            ProfileRow(icon: "bell.fill", title: "Notifications")
                        }
                        
                        Toggle(isOn: $darkModeEnabled) {
                            ProfileRow(icon: "moon.fill", title: "Dark Mode")
                        }
                    }
                    
                    // Support Section
                    ProfileSection(title: "Support") {
                        ProfileButton(icon: "questionmark.circle.fill", title: "Help Center") {
                            // Handle help center
                        }
                        
                        ProfileButton(icon: "envelope.fill", title: "Contact Support") {
                            // Handle contact support
                        }
                    }
                    
                    // Updated Sign Out Button
                    Button(action: { showingSignOutAlert = true }) {
                        Text("Sign Out")
                            .font(.custom("Avenir-Medium", size: 16))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(deeperBlue)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGray6))
            
            Spacer()
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                handleSignOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func handleSignOut() {
        do {
            try firebaseManager.signOut()
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
    }
}

struct ProfileSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Avenir-Heavy", size: 16))
                .foregroundColor(.gray)
                .padding(.leading, 4)
            
            VStack(spacing: 2) {
                content
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.gray.opacity(0.1), radius: 5)
        }
    }
}

struct ProfileButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                ProfileRow(icon: icon, title: title)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 106/255, green: 90/255, blue: 205/255))
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.custom("Avenir", size: 16))
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    ProfileView()
} 
