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
            CalendarModel(text: "M", isSelected: false,position: 0),
            CalendarModel(text: "T", isSelected: false,position: 1),
            CalendarModel(text: "W", isSelected: false,position: 2),
            CalendarModel(text: "T", isSelected: false,position: 3),
            CalendarModel(text: "F", isSelected: false,position: 4),
            CalendarModel(text: "S", isSelected: false,position: 5),
            CalendarModel(text: "S", isSelected: false,position: 6)
        ]
        
        calendarMonthModel = [
            CalendarModel(text: "1", isSelected: false,position: 0),
            CalendarModel(text: "2", isSelected: false,position: 1),
            CalendarModel(text: "3", isSelected: false,position: 2),
            CalendarModel(text: "4", isSelected: false,position: 3),
            CalendarModel(text: "5", isSelected: false,position: 4),
            CalendarModel(text: "6", isSelected: false,position: 5),
            CalendarModel(text: "7", isSelected: false,position: 6),
            CalendarModel(text: "8", isSelected: false,position: 7),
            CalendarModel(text: "9", isSelected: false,position: 8),
            CalendarModel(text: "10", isSelected: false,position: 9),
            CalendarModel(text: "11", isSelected: false,position: 10),
            CalendarModel(text: "12", isSelected: false,position: 11),
            CalendarModel(text: "13", isSelected: false,position: 12),
            CalendarModel(text: "14", isSelected: false,position: 13),
            CalendarModel(text: "15", isSelected: false,position: 14),
            CalendarModel(text: "16", isSelected: false,position: 15),
            CalendarModel(text: "17", isSelected: false,position: 16),
            CalendarModel(text: "18", isSelected: false,position: 17),
            CalendarModel(text: "19", isSelected: false,position: 18),
            CalendarModel(text: "20", isSelected: false,position: 19),
            CalendarModel(text: "21", isSelected: false,position: 20),
            CalendarModel(text: "22", isSelected: false,position: 21),
            CalendarModel(text: "23", isSelected: false,position: 22),
            CalendarModel(text: "24", isSelected: false,position: 23),
            CalendarModel(text: "25", isSelected: false,position: 24),
            CalendarModel(text: "26", isSelected: false,position: 25),
            CalendarModel(text: "27", isSelected: false,position: 26),
            CalendarModel(text: "28", isSelected: false,position: 27),
            CalendarModel(text: "29", isSelected: false,position: 28),
            CalendarModel(text: "30", isSelected: false,position: 29),
            CalendarModel(text: "31", isSelected: false,position: 30)
        ]
        
    }
}
