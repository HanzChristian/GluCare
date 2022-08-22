//
//  Medicine+CoreDataProperties.swift
//  
//
//  Created by Richard Mulyadi on 22/08/22.
//
//

import Foundation
import CoreData


extension Medicine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine> {
        return NSFetchRequest<Medicine>(entityName: "Medicine")
    }

    @NSManaged public var eat_time: Int16
    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var time: NSSet?

}

// MARK: Generated accessors for time
extension Medicine {

    @objc(addTimeObject:)
    @NSManaged public func addToTime(_ value: Medicine_Time)

    @objc(removeTimeObject:)
    @NSManaged public func removeFromTime(_ value: Medicine_Time)

    @objc(addTime:)
    @NSManaged public func addToTime(_ values: NSSet)

    @objc(removeTime:)
    @NSManaged public func removeFromTime(_ values: NSSet)

}
