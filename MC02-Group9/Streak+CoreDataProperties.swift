//
//  Streak+CoreDataProperties.swift
//  
//
//  Created by Christophorus Davin on 25/06/22.
//
//

import Foundation
import CoreData


extension Streak {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Streak> {
        return NSFetchRequest<Streak>(entityName: "Streak")
    }

    @NSManaged public var date: Date?

}
