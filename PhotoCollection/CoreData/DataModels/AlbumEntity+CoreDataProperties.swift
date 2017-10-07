//
//  AlbumEntity+CoreDataProperties.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/7/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//
//

import Foundation
import CoreData


extension AlbumEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumEntity> {
        return NSFetchRequest<AlbumEntity>(entityName: "AlbumEntity")
    }

    @NSManaged public var userId: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?

}
