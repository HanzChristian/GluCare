//
//  Medicine_Time+CoreDataProperties.swift
//  
//
//  Created by Christophorus Davin on 15/06/22.
//
//

import Foundation
import CoreData


extension Medicine_Time {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicine_Time> {
        return NSFetchRequest<Medicine_Time>(entityName: "Medicine_Time")
    }

    @NSManaged public var time: String?
    @NSManaged public var medicine: Medicine?

}
