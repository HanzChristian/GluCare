//
//  Log+CoreDataProperties.swift
//  
//
//  Created by Christophorus Davin on 15/06/22.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var action: String?
    @NSManaged public var date: Date?
    @NSManaged public var medicine_name: String?
    @NSManaged public var time: String?

}
