//
//  OverviewView.swift
//  Cascade
//
//  Created by Kari Groszewska on 2/8/25.
//

import SwiftUI

struct OverviewView: View {
    // Custom colors to match app theme - simplified color palette
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    let lightPurple = Color(red: 147/255, green: 112/255, blue: 219/255).opacity(0.6)
    
    // Sample data
    @State private var balance = 5842.50
    @State private var monthlySpending = 1234.56
    @State private var selectedTimeFrame = "This Month"
    let timeFrames = ["This Week", "This Month", "This Year"]
    
    // Add this state variable
    @State private var showingAddTransaction = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Balance Card
                VStack(spacing: 8) {
                    Text("Total Balance")
                        .font(.custom("Avenir", size: 16))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text("$\(balance, specifier: "%.2f")")
                        .font(.custom("Avenir-Heavy", size: 36))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 24) {
                        StatisticView(title: "Income", amount: "+$3,240")
                        StatisticView(title: "Spending", amount: "-$1,234")
                    }
                    .padding(.top, 8)
                }
                .padding(24)
                .background(
                    LinearGradient(gradient: Gradient(colors: [deeperBlue, primaryPurple.opacity(0.8)]),
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .shadow(color: deeperBlue.opacity(0.3), radius: 10)
                
                // Spending Analysis
                VStack(alignment: .leading, spacing: 16) {
                    Text("Spending Analysis")
                        .font(.custom("Avenir-Heavy", size: 20))
                    
                    Picker("Time Frame", selection: $selectedTimeFrame) {
                        ForEach(timeFrames, id: \.self) { timeFrame in
                            Text(timeFrame).tag(timeFrame)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // Updated category colors to be monochromatic
                    SpendingCategoryRow(category: "Food & Dining", amount: 485.50, percentage: 0.35, color: deeperBlue)
                    SpendingCategoryRow(category: "Transportation", amount: 250.00, percentage: 0.20, color: primaryPurple)
                    SpendingCategoryRow(category: "Shopping", amount: 325.75, percentage: 0.25, color: lightPurple)
                    SpendingCategoryRow(category: "Bills", amount: 173.31, percentage: 0.20, color: deeperBlue.opacity(0.6))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.gray.opacity(0.1), radius: 5)
                
                // Quick Actions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Quick Actions")
                        .font(.custom("Avenir-Heavy", size: 20))
                    
                    HStack(spacing: 12) {
                        QuickActionButton(
                            title: "Add Transaction",
                            icon: "plus.circle.fill",
                            color: deeperBlue
                        ) {
                            showingAddTransaction = true
                        }
                        QuickActionButton(title: "View Reports", icon: "chart.bar.fill", color: primaryPurple
                        ) {
                            //TODO: Implement View Reports Quick Action
                            showingAddTransaction = false
                        }
                        QuickActionButton(title: "Set Budget", icon: "dollarsign.circle.fill", color: lightPurple
                        ) {
                            //TODO: Implement Set Budget Quick Action
                            showingAddTransaction = false
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.gray.opacity(0.1), radius: 5)
            }
            .padding()
        }
        .background(Color(UIColor.systemGray6))
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView()
        }
    }
}

struct StatisticView: View {
    let title: String
    let amount: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Text(amount)
                    .font(.custom("Avenir-Heavy", size: 16))
            }
            .foregroundColor(.white)
            
            Text(title)
                .font(.custom("Avenir", size: 14))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

struct SpendingCategoryRow: View {
    let category: String
    let amount: Double
    let percentage: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(category)
                    .font(.custom("Avenir", size: 16))
                Spacer()
                Text("$\(amount, specifier: "%.2f")")
                    .font(.custom("Avenir-Heavy", size: 16))
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * percentage, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                Text(title)
                    .font(.custom("Avenir", size: 14))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(color.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    OverviewView()
} 
