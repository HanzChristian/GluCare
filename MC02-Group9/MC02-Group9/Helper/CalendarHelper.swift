//
//  CalendarHelper.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 27/06/22.
//

import Foundation
import CoreData

class CalendarHelper{
    //singleton
    static let calendarHelper = CalendarHelper()
    
    //attriute
    var calendar = Calendar.current
    
    private init(){
        self.calendar.timeZone = NSTimeZone.local
    }
    
}

