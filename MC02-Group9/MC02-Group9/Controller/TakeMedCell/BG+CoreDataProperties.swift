//
//  BG+CoreDataProperties.swift
//  
//
//  Created by Hanz Christian on 20/10/22.
//
//

import Foundation
import CoreData


extension BG {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BG> {
        return NSFetchRequest<BG>(entityName: "BG")
    }

    @NSManaged public var bg_each_frequency: Int16
    @NSManaged public var bg_frequency: Int16
    @NSManaged public var bg_start_date: Date?
    @NSManaged public var bg_time: String?
    @NSManaged public var bg_type: Int16
    @NSManaged public var time: NSSet?

}

// MARK: Generated accessors for time
extension BG {

    @objc(addTimeObject:)
    @NSManaged public func addToTime(_ value: BG_Time)

    @objc(removeTimeObject:)
    @NSManaged public func removeFromTime(_ value: BG_Time)

    @objc(addTime:)
    @NSManaged public func addToTime(_ values: NSSet)

    @objc(removeTime:)
    @NSManaged public func removeFromTime(_ values: NSSet)

}
