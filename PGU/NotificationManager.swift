//
//  NotificationManager.swift
//  PGU
//
//  Created by Bryan Arambula on 1/27/24.
//

import Foundation
import Foundation
import CoreData

class NotificationManager: ObservableObject {
    @Published var notifications: [Notifi] = []
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchNotifications()
    }

    func fetchNotifications() {
        let request: NSFetchRequest<Notifi> = Notifi.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Notifi.title, ascending: true)]

        do {
            notifications = try context.fetch(request)
        } catch {
            print("Error fetching notifications: \(error)")
        }
    }

    func addNotification(title: String, body: String) {
        let newNotification = Notifi(context: context)
        newNotification.title = title
        newNotification.body = body

        do {
            try context.save()
            fetchNotifications() // Re-fetch the notifications
        } catch {
            print("Error saving notification: \(error)")
        }
    }

    // ... other methods like deleteNotifications etc.
}
