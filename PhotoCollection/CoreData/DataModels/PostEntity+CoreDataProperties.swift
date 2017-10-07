//
//  PostEntity+CoreDataProperties.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/7/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//
//

import Foundation
import CoreData


extension PostEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostEntity> {
        return NSFetchRequest<PostEntity>(entityName: "PostEntity")
    }

    @NSManaged public var userId: String?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var body: String?

}
