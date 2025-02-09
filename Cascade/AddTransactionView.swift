//
//  AddTransactionView.swift
//  Cascade
//
//  Created by Kari Groszewska on 2/8/25.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    
    // Custom colors
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    let lightPurple = Color(red: 147/255, green: 112/255, blue: 219/255).opacity(0.6)
    
    @State private var title = ""
    @State private var amount = ""
    @State private var category = "Food"
    @State private var isExpense = true
    @State private var date = Date()
    
    let categories = ["Food", "Transportation", "Entertainment", "Shopping", "Bills", "Income", "Other"]
    
    var body: some View {
        NavigationView {
            Form {
                // Transaction Type
                Section {
                    Picker("Transaction Type", selection: $isExpense) {
                        Text("Expense").tag(true)
                        Text("Income").tag(false)
                    }
                    .pickerStyle(.segmented)
                    .tint(deeperBlue)
                } header: {
                    Text("Transaction Type")
                        .foregroundColor(deeperBlue)
                }
                
                // Basic Details
                Section {
                    TextField("Title", text: $title)
                        .font(.custom("Avenir", size: 16))
                    
                    HStack {
                        Text("$")
                            .foregroundColor(deeperBlue)
                        TextField("Amount", text: $amount)
                            .font(.custom("Avenir", size: 16))
                            .keyboardType(.decimalPad)
                    }
                    
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    .tint(deeperBlue)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .tint(deeperBlue)
                } header: {
                    Text("Transaction Details")
                        .foregroundColor(deeperBlue)
                }
                
                // Save Button
                Section {
                    Button(action: saveTransaction) {
                        Text("Save Transaction")
                            .font(.custom("Avenir-Medium", size: 16))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .background(isFormValid ? deeperBlue : lightPurple)
                            .cornerRadius(8)
                    }
                    .disabled(!isFormValid)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(deeperBlue)
                }
            }
            .tint(deeperBlue)
        }
    }
    
    private var isFormValid: Bool {
        !title.isEmpty && !amount.isEmpty
    }
    
    private func saveTransaction() {
        // Here you would implement the logic to save the transaction
        // For now, we'll just dismiss the view
        dismiss()
    }
}

#Preview {
    AddTransactionView()
} 