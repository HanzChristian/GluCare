//
//  CalendarHelper.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 27/06/22.
//

import Foundation
import CoreData

class CalendarManager{
    //singleton
    static let calendarManager = CalendarManager()
    
    //attriute
    var calendar = Calendar.current
    
    private init(){
        self.calendar.timeZone = NSTimeZone.local
    }
    
}

