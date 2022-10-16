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
    var calendarMonthModel:[CalendarModel]?
    
    private init(){
        calendarModel = [
            CalendarModel(text: "M", isSelected: false),
            CalendarModel(text: "T", isSelected: false),
            CalendarModel(text: "W", isSelected: false),
            CalendarModel(text: "T", isSelected: false),
            CalendarModel(text: "F", isSelected: false),
            CalendarModel(text: "S", isSelected: false),
            CalendarModel(text: "S", isSelected: false)
        ]
        
        calendarMonthModel = [
            CalendarModel(text: "1", isSelected: false),
            CalendarModel(text: "2", isSelected: false),
            CalendarModel(text: "3", isSelected: false),
            CalendarModel(text: "4", isSelected: false),
            CalendarModel(text: "5", isSelected: false),
            CalendarModel(text: "6", isSelected: false),
            CalendarModel(text: "7", isSelected: false),
            CalendarModel(text: "8", isSelected: false),
            CalendarModel(text: "9", isSelected: false),
            CalendarModel(text: "10", isSelected: false),
            CalendarModel(text: "11", isSelected: false),
            CalendarModel(text: "12", isSelected: false),
            CalendarModel(text: "13", isSelected: false),
            CalendarModel(text: "14", isSelected: false),
            CalendarModel(text: "15", isSelected: false),
            CalendarModel(text: "16", isSelected: false),
            CalendarModel(text: "17", isSelected: false),
            CalendarModel(text: "18", isSelected: false),
            CalendarModel(text: "19", isSelected: false),
            CalendarModel(text: "20", isSelected: false),
            CalendarModel(text: "21", isSelected: false),
            CalendarModel(text: "22", isSelected: false),
            CalendarModel(text: "23", isSelected: false),
            CalendarModel(text: "24", isSelected: false),
            CalendarModel(text: "25", isSelected: false),
            CalendarModel(text: "26", isSelected: false),
            CalendarModel(text: "27", isSelected: false),
            CalendarModel(text: "28", isSelected: false),
            CalendarModel(text: "29", isSelected: false),
            CalendarModel(text: "30", isSelected: false),
            CalendarModel(text: "31", isSelected: false)
        ]
        
    }
}
