//
//  Log+CoreDataProperties.swift
//  
//
//  Created by Christophorus Davin on 09/06/22.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var medicine_name: String?
    @NSManaged public var date: Date?
    @NSManaged public var time: String?
    @NSManaged public var action: String?

}
