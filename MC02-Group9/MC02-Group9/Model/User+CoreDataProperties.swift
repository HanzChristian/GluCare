//
//  User+CoreDataProperties.swift
//  
//
//  Created by Hanz Christian on 27/10/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var user_role: Int16

}
