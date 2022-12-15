//
//  GulaDarahStatistikViewController+DateSelector.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 14/12/22.
//

import UIKit

extension GulaDarahStatistikViewController{
    
    func updateDateField(){
        var newDate: Date?
        let dateFormatter = DateFormatter()
        
        if selected == 0 {
            newDate = calendarHelper.addDays(date: today, days: dateController)
            
            dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
            dateField.text = "\(dateFormatter.string(from: newDate!))"
        }else if selected == 1{
            newDate = calendarHelper.addDays(date: today, days: (dateController * 7))
            let startDate = calendarHelper.addDays(date: newDate!, days: -6)
            
            dateFormatter.dateFormat = "d"
            let startDateString = "\(dateFormatter.string(from: startDate))"
            dateFormatter.dateFormat = "d MMMM yyyy"
            let endDateString = "\(dateFormatter.string(from: newDate!))"
            
            dateField.text = "\(startDateString) - \(endDateString)"
        }else{
            newDate = calendarHelper.calendar.date(byAdding: .month, value: dateController, to: today)!
            
            let startDate = calendarHelper.addDays(date: newDate!, days: -6)
            
            dateFormatter.dateFormat = "MMMM yyyy"
            let startDateString = "\(dateFormatter.string(from: startDate))"
            
            dateField.text = "\(startDateString)"
        }
    }
}
