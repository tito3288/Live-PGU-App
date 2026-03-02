//
//  Persistence.swift
//  PGU
//
//  Created by Bryan Arambula on 1/12/24.
//

//
//  Persistence.swift
//  DataTest
//
//  Created by Bryan Arambula on 1/12/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "MyData")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



