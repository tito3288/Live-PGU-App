//
//  InboxView.swift
//  PGU
//
//  Created by Bryan Arambula on 12/4/23.
//

import SwiftUI
import CoreData
import Firebase



struct FirestoreNotification: Identifiable {
    var id: String  // Document ID
    var title: String
    var body: String
}

extension FirestoreNotification {
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let title = data["title"] as? String, let body = data["body"] as? String else {
            return nil
        }
        self.id = document.documentID
        self.title = title
        self.body = body
    }
}

struct InboxView: View {
    
    @State private var firestoreNotifications = [FirestoreNotification]()


    @StateObject private var chatBotModel = ChatBotModel() // Instantiate ChatBotModel
    @State private var isChatPresented = false // To control chat view presentation

    @State private var isMenuOpen: Bool = false

    //MARK: LOGIC TO DISPLAY FCM NOTIFICATION ON THE INBOXVIEW
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Notifi.title, ascending: true)],
        animation: .default)
    
    private var notifications: FetchedResults<Notifi>
    
    
    private func fetchNotificationsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("notifications").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.firestoreNotifications = querySnapshot?.documents.compactMap { document -> FirestoreNotification? in
                    return FirestoreNotification(document: document)
                } ?? []
            }
        }
    }

    
    var body: some View {
        ZStack {
            VStack {
                HamburgerMenu(isMenuOpen: $isMenuOpen)
                    .navigationBarBackButtonHidden(true)
                    .frame(height: 50)
                    .padding(.bottom, 30)
                
                Text("INBOX")
                    .font(.title)
                    .fontWeight(.bold)
                
                List {
                    ForEach(notifications, id: \.self) { notification in
                        VStack(alignment: .leading, spacing: 0) {
                            Text(notification.title ?? "Unknown Title")
                                .font(.title2)
                                .foregroundColor(Color(hex: "c7972b"))
                                .fontWeight(.bold)
                            
                            Text(notification.body ?? "No content")
                                .font(.body)
                        }
                    }
                    .onDelete(perform: deleteNotifications)
                }
                .listStyle(PlainListStyle())
                
//                List {
//                    ForEach(firestoreNotifications, id: \.id) { notification in
//                        VStack(alignment: .leading, spacing: 0) {
//                            Text(notification.title)
//                                .font(.title2)
//                                .foregroundColor(Color(hex: "c7972b"))
//                                .fontWeight(.bold)
//                            
//                            Text(notification.body)
//                                .font(.body)
//                        }
//                    }
//                    .onDelete(perform: deleteNotificationFromFirestore)
//
//                }
//                .listStyle(PlainListStyle())
                
                
                //THIS IS THE CHAT ICON
                HStack{
                    Spacer()
                    Button(action: {
                        isChatPresented = true
                    }, label: {
                        Image("chat-icon") // Ensure you have this image in your assets
                            .padding()
                    })
                    .sheet(isPresented: $isChatPresented) {
                        ChatBotView(chatBotModel: chatBotModel) // Pass the chatBotModel to the chat view
                    }

                    
                }
                
                Divider()
                
                HStack {
                    
                    Spacer()

                    NavigationLink(destination: HomeView()) {
                        VStack{
                            Image(systemName: "person")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)// Example icon
                            Text("Home")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)

                        }
                    }

                        
                    
                    Spacer()
                    
                        VStack{
                            Image(systemName: "tray.full")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)// Example icon
                            Text("Inbox")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)

                        }

                        
                    
                    Spacer()
  
                    NavigationLink(destination: CampsView()) {
                        VStack{
                            Image(systemName: "mappin.and.ellipse")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)// Example icon
                            Text("Camps")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)

                        }
                    }

                        
                    
                    Spacer()
                    
                    NavigationLink(destination: ResourcesView()) {

                        VStack{
                            Image(systemName: "basketball")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25, height: 25)// Example icon
                            Text("Resources")
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                        }
                        
                    }

                    Spacer()

                }
                .padding(.top)
                .background(Color.white)
                
                
            }
            .onAppear {
                fetchNotificationsFromFirestore()
            }
            
            
            //MARK: LOGIC FOR THE SLIDING MENU.
            if isMenuOpen {
                MenuView(isMenuOpen: $isMenuOpen)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(1) // Ensure the menu is on top
            }
        }
  
    }
    

    
    //MARK: LOGIC TO DELETE NOTIFICATIOMN FROM USERS DEVICE AND CORE DATA.
    private func deleteNotifications(offsets: IndexSet) {
        withAnimation {
            offsets.map { notifications[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    
    
    private func deleteNotificationFromFirestore(offsets: IndexSet) {
        let db = Firestore.firestore()
        
        offsets.forEach { index in
            // Get the ID of the document to delete
            let docId = firestoreNotifications[index].id
            
            // Delete the document from Firestore
            db.collection("notifications").document(docId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    // Remove the item from the local array to update the UI
                    firestoreNotifications.remove(at: index)
                }
            }
        }
    }

    
    
}

#Preview {
    InboxView()
}
