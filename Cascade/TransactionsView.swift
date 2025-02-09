//
//  TransactionsView.swift
//  Cascade
//
//  Created by Kari Groszewska on 2/8/25.
//

import SwiftUI

struct TransactionsView: View {
    // Custom colors to match app theme
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    let lightPurple = Color(red: 147/255, green: 112/255, blue: 219/255).opacity(0.6)
    
    @State private var searchText = ""
    @State private var selectedFilter = "All"
    let filterOptions = ["All", "Income", "Expenses"]
    
    // Sample transactions data
    let transactions = [
        Transaction(title: "Grocery Shopping", amount: -82.50, category: "Food", date: "Today", icon: "cart.fill"),
        Transaction(title: "Salary Deposit", amount: 2500.00, category: "Income", date: "Yesterday", icon: "dollarsign.circle.fill"),
        Transaction(title: "Coffee Shop", amount: -4.50, category: "Food", date: "Yesterday", icon: "cup.and.saucer.fill"),
        Transaction(title: "Gas Station", amount: -45.00, category: "Transportation", date: "Feb 15", icon: "fuelpump.fill"),
        Transaction(title: "Netflix", amount: -15.99, category: "Entertainment", date: "Feb 14", icon: "play.tv.fill"),
        Transaction(title: "Freelance Work", amount: 350.00, category: "Income", date: "Feb 13", icon: "briefcase.fill")
    ]
    
    @State private var showingAddTransaction = false
    
    var filteredTransactions: [Transaction] {
        transactions.filter { transaction in
            let matchesSearch = searchText.isEmpty || 
                transaction.title.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter = selectedFilter == "All" ||
                (selectedFilter == "Income" && transaction.amount > 0) ||
                (selectedFilter == "Expenses" && transaction.amount < 0)
            
            return matchesSearch && matchesFilter
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and Filter Section
            VStack(spacing: 12) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search transactions", text: $searchText)
                        .font(.custom("Avenir", size: 16))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.gray.opacity(0.1), radius: 5)
                
                // Filter Pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filterOptions, id: \.self) { filter in
                            FilterPill(title: filter, isSelected: filter == selectedFilter) {
                                selectedFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(color: Color.gray.opacity(0.1), radius: 5)
            
            // Transactions List
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(filteredTransactions) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
                .padding()
            }
            .background(Color(UIColor.systemGray6))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddTransaction = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(deeperBlue)
                        .font(.system(size: 22))
                }
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView()
        }
    }
}

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let category: String
    let date: String
    let icon: String
}

struct TransactionRow: View {
    let transaction: Transaction
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            Image(systemName: transaction.icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(primaryPurple)
                .cornerRadius(12)
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.custom("Avenir-Heavy", size: 16))
                
                Text(transaction.category)
                    .font(.custom("Avenir", size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Amount and Date
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "$%.2f", abs(transaction.amount)))
                    .font(.custom("Avenir-Heavy", size: 16))
                    .foregroundColor(transaction.amount >= 0 ? .green : .red)
                
                Text(transaction.date)
                    .font(.custom("Avenir", size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Avenir-Medium", size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? deeperBlue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

#Preview {
    NavigationView {
        TransactionsView()
    }
} 
