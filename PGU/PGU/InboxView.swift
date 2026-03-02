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

// MARK: - Inbox Filter
enum InboxFilter: String, CaseIterable {
    case all = "All"
    case unread = "Unread"
    case promotions = "Promotions"
    case updates = "Updates"
}

struct InboxView: View {

    @State private var firestoreNotifications = [FirestoreNotification]()
    @StateObject private var chatBotModel = ChatBotModel()
    @State private var isChatPresented = false
    @EnvironmentObject var navigationState: NavigationState
    @State private var selectedFilter: InboxFilter = .all

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
            // Background
            Color(red: 0.96, green: 0.96, blue: 0.96)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        withAnimation {
                            navigationState.isMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(.black)
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("PG")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Rectangle()
                            .fill(Color(hex: "c7972b"))
                            .frame(width: 3, height: 24)
                        Text("U")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }

                    Spacer()

                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell")
                            .font(.title2)
                            .foregroundColor(.black)
                        Circle()
                            .fill(Color(hex: "c7972b"))
                            .frame(width: 8, height: 8)
                            .offset(x: 4, y: -4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                .navigationBarBackButtonHidden(true)

                // Inbox title + unread badge
                HStack {
                    Text("Inbox")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)

                    Spacer()

                    if notifications.count > 0 {
                        Text("\(notifications.count) Unread")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "c7972b"))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
                .background(Color.white)

                // Filter pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(InboxFilter.allCases, id: \.self) { filter in
                            Button(action: {
                                selectedFilter = filter
                            }) {
                                Text(filter.rawValue)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(selectedFilter == filter ? .white : Color(red: 0.11, green: 0.22, blue: 0.37))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedFilter == filter ? Color(red: 0.11, green: 0.22, blue: 0.37) : Color.clear)
                                    .cornerRadius(18)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(Color(red: 0.11, green: 0.22, blue: 0.37).opacity(0.3), lineWidth: selectedFilter == filter ? 0 : 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 12)
                .background(Color.white)

                // Notification list
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // TODAY section
                        if !notifications.isEmpty {
                            Text("TODAY")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 8)

                            ForEach(notifications, id: \.self) { notification in
                                InboxNotificationCard(
                                    title: notification.title ?? "Unknown Title",
                                    message: notification.body ?? "No content"
                                )
                                .padding(.horizontal, 20)
                                .padding(.bottom, 4)
                            }
                        }

                        // Empty state
                        if notifications.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "tray")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray.opacity(0.4))
                                Text("No messages yet")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.gray)
                                Text("Notifications and updates will appear here")
                                    .font(.subheadline)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 80)
                        }

                        Color.clear.frame(height: 100)
                    }
                }

                // Chat FAB
                // (overlaid via ZStack below)

            }

            // Chat FAB overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isChatPresented = true
                    }) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(hex: "c7972b"))
                            .clipShape(Circle())
                            .shadow(color: Color(hex: "c7972b").opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 80)
                }
            }
            .sheet(isPresented: $isChatPresented) {
                ChatBotView(chatBotModel: chatBotModel)
            }

            // Sliding menu overlay
            if navigationState.isMenuOpen {
                MenuView(isMenuOpen: $navigationState.isMenuOpen, activePage: .inbox)
                    .frame(width: UIScreen.main.bounds.width)
                    .transition(.move(edge: .leading))
                    .zIndex(4)
            }
        }
        .toolbar(navigationState.isMenuOpen ? .hidden : .visible, for: .tabBar)
        .onAppear {
            fetchNotificationsFromFirestore()
        }
    }

    // MARK: - Delete Notifications
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
            let docId = firestoreNotifications[index].id
            db.collection("notifications").document(docId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    firestoreNotifications.remove(at: index)
                }
            }
        }
    }
}

// MARK: - Inbox Notification Card
struct InboxNotificationCard: View {
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Icon circle
            ZStack {
                Circle()
                    .fill(Color(hex: "c7972b").opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: "basketball.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "c7972b"))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)

                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}

#Preview {
    InboxView()
}
