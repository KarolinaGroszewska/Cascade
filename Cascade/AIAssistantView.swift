import SwiftUI

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
}

struct AIAssistantView: View {
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    @State private var isTyping: Bool = false
    
    // Custom colors to match app theme
    let primaryPurple = Color(red: 147/255, green: 112/255, blue: 219/255)
    let deeperBlue = Color(red: 106/255, green: 90/255, blue: 205/255)
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat header
            VStack(spacing: 4) {
                Text("Financial Assistant")
                    .font(.custom("Avenir-Heavy", size: 20))
                Text("Ask me anything about your finances!")
                    .font(.custom("Avenir", size: 14))
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
            
            // Chat messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }
                        if isTyping {
                            TypingIndicator()
                                .padding(.leading)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
            }
            
            // Suggestion chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(["💰 Budget Analysis", "📊 Spending Trends", "💡 Saving Tips", "🎯 Financial Goals"], id: \.self) { suggestion in
                        Button(action: {
                            sendMessage(suggestion)
                        }) {
                            Text(suggestion)
                                .font(.custom("Avenir", size: 14))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.gray.opacity(0.2), radius: 3)
                        }
                    }
                }
                .padding()
            }
            
            // Message input
            HStack(spacing: 12) {
                TextField("Ask your financial question...", text: $newMessage)
                    .font(.custom("Avenir", size: 16))
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: Color.gray.opacity(0.1), radius: 3)
                
                Button(action: {
                    sendMessage(newMessage)
                }) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(deeperBlue)
                }
                .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding()
            .background(Color.white)
        }
        .background(Color(UIColor.systemGray6))
        .onAppear {
            addWelcomeMessage()
        }
    }
    
    private func sendMessage(_ content: String) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = Message(content: content, isUser: true, timestamp: Date())
        messages.append(userMessage)
        newMessage = ""
        
        // Simulate AI typing
        isTyping = true
        
        // Simulate AI response after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            let response = "Here's what I found about \(content.lowercased())..."
            messages.append(Message(content: response, isUser: false, timestamp: Date()))
        }
    }
    
    private func addWelcomeMessage() {
        let welcome = Message(
            content: "Hi! I'm your AI financial assistant. I can help you with budgeting, spending analysis, and financial advice. What would you like to know?",
            isUser: false,
            timestamp: Date()
        )
        messages.append(welcome)
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .font(.custom("Avenir", size: 16))
                    .padding(12)
                    .background(message.isUser ? Color(red: 106/255, green: 90/255, blue: 205/255) : Color.white)
                    .foregroundColor(message.isUser ? .white : .black)
                    .cornerRadius(20)
                    .shadow(color: Color.gray.opacity(0.1), radius: 3)
            }
            
            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var numberOfDots = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray.opacity(numberOfDots > index ? 1 : 0.3))
                    .frame(width: 8, height: 8)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
                withAnimation {
                    numberOfDots = (numberOfDots + 1) % 4
                }
            }
        }
    }
} 

#Preview {
    AIAssistantView()
}
