//
//  CalendarViewModel.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 13/10/22.
//

import Foundation

class CalendarViewModel{
    static let calendarViewModel = CalendarViewModel()
    
    var calendarModel:[CalendarModel]?
    
    private init(){
        calendarModel = [
            CalendarModel(text: "M", isSelected: false),
            CalendarModel(text: "T", isSelected: false),
            CalendarModel(text: "W", isSelected: false)
        ]
        
    }
}
