//
//  UserEntity+CoreDataProperties.swift
//  PhotoCollection
//
//  Created by Michael Jester on 10/7/17.
//  Copyright © 2017 Michael Jester. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?

}
