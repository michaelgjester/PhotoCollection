//
//  CoreDataStack.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/7/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "PhotoCollection")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext() {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - CRUD operations for model objects to core data
    
    static func insertPostArray(postArray:[Post]){
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        for post:Post in postArray{
            if let postEntity = NSEntityDescription.insertNewObject(forEntityName: "PostEntity", into: context) as? PostEntity {
                postEntity.userId = post.userId
                postEntity.id = post.id
                postEntity.title = post.title
                postEntity.body = post.body
            }
        }

        saveContext()
    }

}



extension CoreDataStack {
    
    func applicationDocumentsDirectory() -> String {
        // The directory the application uses to store the Core Data store file.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            return url.absoluteString
        } else {
            return "(no application documents directory found)"
        }
    }
}

