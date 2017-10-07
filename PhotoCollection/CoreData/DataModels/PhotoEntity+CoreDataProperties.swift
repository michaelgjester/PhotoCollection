//
//  PhotoEntity+CoreDataProperties.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/7/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//
//

import Foundation
import CoreData


extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var albumId: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var thumbnailUrl: String?

}
