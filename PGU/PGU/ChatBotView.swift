//
//  ChatBotView.swift
//  PGU
//
//  Created by Bryan Arambula on 2/15/24.
//

import SwiftUI

struct ChatBotView: View {
    @ObservedObject var chatBotModel = ChatBotModel()
    @State private var userInput: String = ""
    @State private var chatHistory: [(id: UUID, message: String, isUser: Bool)] = []
    @State private var isBotTyping = false

    @State private var scrollToMessageId: UUID?

    
    var body: some View {


        VStack {
            ScrollViewReader { scrollView in
                List {
                    ForEach(chatHistory, id: \.id) { chatEntry in
                        HStack {
                            if chatEntry.isUser {
                                Spacer()
                                Text(chatEntry.message).foregroundColor(Color(hex: "0f2d53"))
                            } else {
                                Text(chatEntry.message).foregroundColor(Color(hex: "c7972b"))
                                Spacer()
                            }
                        }
                    }
                    if isBotTyping {
                        HStack {
                            Spacer()
                            Text("Typing...").foregroundColor(.gray)
                            Spacer()
                        }.transition(.opacity) // Optional: add a fade transition
                    }
                }
                .onChange(of: scrollToMessageId) { _ in
                    if let messageId = scrollToMessageId {
                        withAnimation {
                            scrollView.scrollTo(messageId, anchor: .bottom)
                        }
                    }
                }
            }
//                .listStyle(PlainListStyle()) // Removes list lines
//                .background(Color.clear) // Makes list background transparent

                
                
                HStack {
                    TextField("Ask me something...", text: $userInput)
                        .padding(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 20)) // Adjust left padding
                        .background(.white)
                        .foregroundColor(Color(hex: "0f2d53"))
                        .font(.body)
                        .bold()
                        .cornerRadius(37)
                        .frame(width: 300) // Set a specific width
                        .overlay(
                            RoundedRectangle(cornerRadius: 37)
                                .stroke(Color(hex: "0f2d53"), lineWidth: 2) // Customize border color and line width
                        )
                    
                    Button(action: {
                        sendMessage()
                        
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.largeTitle)
                    }
                    .padding(.leading)

                    .foregroundColor(userInput.isEmpty ? Color.gray.opacity(0.5) : Color(hex: "c7972b")) // Change color based on userInput
                    .disabled(userInput.isEmpty) // Disable button when userInput is empty

                }
                .padding()
                
            }
            .onAppear {
                chatHistory.append((id: UUID(), message: "Is there anything I can help you with?", isUser: false))
            }
    }
    
    func sendMessage() {
        guard !userInput.isEmpty else { return }
        
        let userMessage = userInput // Capture userInput before clearing it
        let userMessageId = UUID() // Generate UUID for the user message
        chatHistory.append((id: userMessageId, message: userInput, isUser: true))
        scrollToMessageId = userMessageId // Update scrollToMessageId to trigger scroll
        
        userInput = "" // Clear input field
        
        isBotTyping = true
        
        let delayInSeconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            if let answer = self.chatBotModel.answer(for: userMessage) { // Use captured userInput value
                let botMessageId = UUID()
                self.chatHistory.append((id: botMessageId, message: answer, isUser: false))
                self.scrollToMessageId = botMessageId
            } else {
                let fallbackMessageId = UUID()
                self.chatHistory.append((id: fallbackMessageId, message: "I'm not sure about that. Please email us for more information.", isUser: false))
                self.scrollToMessageId = fallbackMessageId
            }
            self.isBotTyping = false
        }
    }


    
    
}


#Preview {
    ChatBotView()
}
