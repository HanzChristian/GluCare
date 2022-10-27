//
//  BG_Time+CoreDataProperties.swift
//  
//
//  Created by Hanz Christian on 27/10/22.
//
//

import Foundation
import CoreData


extension BG_Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BG_Time> {
        return NSFetchRequest<BG_Time>(entityName: "BG_Time")
    }

    @NSManaged public var bg_date_item: Int16
    @NSManaged public var bg: BG?

}
