//
//  CoreDataManager.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/7/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
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
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
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
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
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
    
    static func insertUserArray(userArray:[User]){
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        for user:User in userArray{
            if let userEntity = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as? UserEntity {
                userEntity.id = user.id
                userEntity.name = user.name
                userEntity.username = user.username
                userEntity.email = user.email
                userEntity.address = user.address
            }
        }
        
        saveContext()
    }
    
    static func insertAlbumArray(albumArray:[Album]){
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        for album:Album in albumArray{
            if let albumEntity = NSEntityDescription.insertNewObject(forEntityName: "AlbumEntity", into: context) as? AlbumEntity {
                albumEntity.userId = album.userId
                albumEntity.id = album.id
                albumEntity.title = album.title
            }
        }
        
        saveContext()
    }
    
    static func insertPhotoArray(photoArray:[Photo]){
        
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        
        for photo:Photo in photoArray{
            if let photoEntity = NSEntityDescription.insertNewObject(forEntityName: "PhotoEntity", into: context) as? PhotoEntity {
                photoEntity.albumId = photo.albumId
                photoEntity.id = photo.id
                photoEntity.title = photo.title
                photoEntity.url = photo.url
                photoEntity.thumbnailUrl = photo.thumbnailUrl
            }
        }
        
        saveContext()
    }
    
    static func clearData(){
        do {
            
            let postsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: PostEntity.self))
            let usersFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: UserEntity.self))
            let albumsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: AlbumEntity.self))
            let photosFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: PhotoEntity.self))

            clearDataForFetchRequest(fetchRequest: postsFetchRequest)
            clearDataForFetchRequest(fetchRequest: usersFetchRequest)
            clearDataForFetchRequest(fetchRequest: albumsFetchRequest)
            clearDataForFetchRequest(fetchRequest: photosFetchRequest)

        }
    }
    
    static private func clearDataForFetchRequest(fetchRequest:NSFetchRequest<NSFetchRequestResult>){
        let context = CoreDataManager.sharedInstance.persistentContainer.viewContext
        do {
            let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
            _ = objects.map{$0.map{context.delete($0)}}
            saveContext()
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
    }

}



extension CoreDataManager {
    
    func applicationDocumentsDirectory() -> String {
        // The directory the application uses to store the Core Data store file.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            return url.absoluteString
        } else {
            return "(no application documents directory found)"
        }
    }
}

