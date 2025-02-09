import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            // Dashboard/Overview Tab
            NavigationView {
                OverviewView()
            }
            .tabItem {
                Image(systemName: "chart.pie.fill")
                Text("Overview")
            }
            
            // Transactions Tab
            NavigationView {
                TransactionsView()
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Transactions")
            }
            
            // Budget Tab
            NavigationView {
                BudgetView()
            }
            .tabItem {
                Image(systemName: "dollarsign.circle.fill")
                Text("Budget")
            }
            
            // AI Assistant Tab
            NavigationView {
                AIAssistantView()                
            }
            .tabItem {
                Image(systemName: "sparkles")
                Text("AI Assistant")
            }
            
            // Profile Tab
            NavigationView {
                ProfileView()
                    .navigationBarHidden(true)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
        }
        .tint(Color(red: 106/255, green: 90/255, blue: 205/255)) // Match the deeperBlue color
    }
} 

#Preview {
    HomeView()
}
