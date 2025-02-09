//
//  BudgetView.swift
//  Cascade
//
//  Created by Kari Groszewska on 2/8/25.
//

import SwiftUI

struct BudgetView: View {
    // Custom colors
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    let lightPurple = Color(red: 147/255, green: 112/255, blue: 219/255).opacity(0.6)
    
    @State private var selectedMonth = Date()
    @State private var showingAddBudget = false
    
    // Sample budget data
    let budgetCategories = [
        BudgetCategory(name: "Food & Dining", spent: 450, limit: 600, icon: "fork.knife"),
        BudgetCategory(name: "Transportation", spent: 180, limit: 300, icon: "car.fill"),
        BudgetCategory(name: "Entertainment", spent: 120, limit: 200, icon: "tv.fill"),
        BudgetCategory(name: "Shopping", spent: 350, limit: 400, icon: "bag.fill"),
        BudgetCategory(name: "Bills", spent: 800, limit: 1000, icon: "doc.text.fill"),
        BudgetCategory(name: "Healthcare", spent: 100, limit: 300, icon: "heart.fill")
    ]
    
    var totalSpent: Double {
        budgetCategories.reduce(0) { $0 + $1.spent }
    }
    
    var totalBudget: Double {
        budgetCategories.reduce(0) { $0 + $1.limit }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Monthly Overview Card
                VStack(spacing: 16) {
                    // Month Selector
                    HStack {
                        Button(action: { selectPreviousMonth() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                        
                        Text(monthYearString(from: selectedMonth))
                            .font(.custom("Avenir-Heavy", size: 20))
                            .foregroundColor(.white)
                        
                        Button(action: { selectNextMonth() }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                    }
                    
                    // Total Budget Progress
                    VStack(spacing: 8) {
                        HStack {
                            Text("Total Budget")
                                .font(.custom("Avenir", size: 16))
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(Int(totalSpent)) / $\(Int(totalBudget))")
                                .font(.custom("Avenir-Heavy", size: 16))
                                .foregroundColor(.white)
                        }
                        
                        ProgressBar(value: totalSpent / totalBudget, color: .white)
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(gradient: Gradient(colors: [deeperBlue, primaryPurple]),
                                 startPoint: .topLeading,
                                 endPoint: .bottomTrailing)
                )
                .cornerRadius(20)
                .shadow(color: deeperBlue.opacity(0.3), radius: 10)
                
                // Budget Categories
                VStack(spacing: 16) {
                    HStack {
                        Text("Budget Categories")
                            .font(.custom("Avenir-Heavy", size: 20))
                        Spacer()
                        Button(action: { showingAddBudget = true }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(deeperBlue)
                                .font(.system(size: 22))
                        }
                    }
                    
                    ForEach(budgetCategories) { category in
                        BudgetCategoryRow(category: category)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(UIColor.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddBudget) {
            AddBudgetView()
        }
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func selectPreviousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
    
    private func selectNextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
}

struct BudgetCategory: Identifiable {
    let id = UUID()
    let name: String
    let spent: Double
    let limit: Double
    let icon: String
    
    var percentage: Double {
        spent / limit
    }
}

struct BudgetCategoryRow: View {
    let category: BudgetCategory
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                // Icon
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color(red: 106/255, green: 90/255, blue: 205/255))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.name)
                        .font(.custom("Avenir-Heavy", size: 16))
                    
                    Text("$\(Int(category.spent)) of $\(Int(category.limit))")
                        .font(.custom("Avenir", size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Percentage
                Text("\(Int(category.percentage * 100))%")
                    .font(.custom("Avenir-Heavy", size: 16))
                    .foregroundColor(category.percentage >= 0.9 ? .red : .primary)
            }
            
            ProgressBar(
                value: category.percentage,
                color: category.percentage >= 0.9 ? .red : Color(red: 106/255, green: 90/255, blue: 205/255)
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.1), radius: 5)
    }
}

struct ProgressBar: View {
    let value: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 8)
                    .cornerRadius(4)
                
                Rectangle()
                    .fill(color)
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width), height: 8)
                    .cornerRadius(4)
            }
        }
        .frame(height: 8)
    }
}

struct AddBudgetView: View {
    @Environment(\.dismiss) var dismiss
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    
    @State private var categoryName = ""
    @State private var budgetAmount = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Category Name", text: $categoryName)
                        .font(.custom("Avenir", size: 16))
                    
                    HStack {
                        Text("$")
                            .foregroundColor(deeperBlue)
                        TextField("Budget Amount", text: $budgetAmount)
                            .font(.custom("Avenir", size: 16))
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Add Budget Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(deeperBlue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Add save logic here
                        dismiss()
                    }
                    .foregroundColor(deeperBlue)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        BudgetView()
    }
} 