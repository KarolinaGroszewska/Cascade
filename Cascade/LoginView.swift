//
//  LoginView.swift
//  Cascade
//
//  Created by Kari Groszewska on 2/8/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @StateObject private var firebaseManager = FirebaseManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    // Custom colors
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.white, deeperBlue.opacity(0.2)]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
                
                VStack(spacing: 5) {
                    // Logo and Title
                    VStack(spacing: 8) {
                        HStack(spacing: 0) {
                            Text("Ca")
                                .font(.custom("Avenir-Heavy", size: 40))
                                .fontWeight(.bold)
                            Image(systemName: "dollarsign.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(deeperBlue)
                            Text("cade")
                                .font(.custom("Avenir-Heavy", size: 40))
                                .fontWeight(.bold)
                        }
                        Text("Your Financial BFF")
                            .font(.custom("Avenir", size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 80)
                    
                    // Login Form
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .font(.custom("Avenir", size: 16))
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                        
                        SecureField("Password", text: $password)
                            .font(.custom("Avenir", size: 16))
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white)
                                    .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2)
                            )
                        
                        if !isLoginMode {
                            Button("Forgot Password?") {
                                resetPassword()
                            }
                            .font(.custom("Avenir", size: 14))
                            .foregroundColor(deeperBlue)
                        }
                        
                        Button(action: handleAuthentication) {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(isLoginMode ? "Log In" : "Sign Up")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(deeperBlue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                        .font(.custom("Avenir-Medium", size: 18))
                        .shadow(color: Color.purple.opacity(0.3), radius: 5, x: 0, y: 3)
                        .disabled(isLoading)
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    
                    // Toggle between Login and Signup
                    Button(action: { isLoginMode.toggle() }) {
                        Text(isLoginMode ? "New here? Join the fun!" : "Already part of the squad? Log in!")
                            .foregroundColor(deeperBlue)
                            .font(.custom("Avenir", size: 16))
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationDestination(isPresented: $firebaseManager.isLoggedIn) {
                HomeView()
                    .navigationBarBackButtonHidden()
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleAuthentication() {
        isLoading = true
        
        Task {
            do {
                if isLoginMode {
                    try await firebaseManager.signIn(email: email, password: password)
                } else {
                    try await firebaseManager.signUp(email: email, password: password)
                }
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
            
            isLoading = false
        }
    }
    
    private func resetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Please enter your email address"
            showingError = true
            return
        }
        
        Task {
            do {
                try await firebaseManager.resetPassword(email: email)
                errorMessage = "Password reset email sent. Please check your inbox."
                showingError = true
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
            }
        }
    }
}

#Preview {
    LoginView()
}
