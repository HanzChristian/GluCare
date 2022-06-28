//
//  StreakHelper.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 27/06/22.
//

import Foundation
import UIKit

class StreakManager{
    //singleton
    static let streakManager = StreakManager()
    
    //helper
    let calendarManager = CalendarManager.calendarManager
    let coreDataManager = CoreDataManager.coreDataManager
    
    private init(){
        
    }
    
    func validateNewStreak(daySelected: Date, tableView: UITableView){
        // check di hari yang sama apa tidak
        let dateNow = calendarManager.calendar.startOfDay(for: Date())
        let dateCalendar = calendarManager.calendar.startOfDay(for: daySelected)
        
        if(dateNow != dateCalendar){
            return
        }
        
        coreDataManager.fetchStreak()
        coreDataManager.fetchMeds()
        
        coreDataManager.fetchMedicine(tableView: tableView)
        coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        
        let medCount = coreDataManager.items!.count
        var keTakeCount = 0
        
        print("Ke Take")
        for i in stride(from: 0, to: medCount, by: 1) {
            if(coreDataManager.keTake[i] == 1){
                keTakeCount += 1
            }
        }
        
        if(medCount == keTakeCount){
            if(coreDataManager.streaks!.count == 0){
                // Kondisi ga ada streak
                coreDataManager.addStreak()
            }else{
                // Kondisi udah ada streak di hari sebelumnya

                // Get today's beginning & end
                let dateFrom = calendarManager.calendar.startOfDay(for: Date())
                
                var lastDate = coreDataManager.streaks![coreDataManager.streaks!.count - 1].date
                
                if(lastDate == dateFrom){
                    print("ADA DI HARI YANG SAMA UDAH KETAMBAH")
                    
                    // Streak nya udah ketambah di hari yg sama
                    return
                }else{
                    // Hitung Jarak Hari nya
                    lastDate!.addTimeInterval(86400)
                    if(lastDate == dateFrom){
                        // Kalau jaraknya 1 hari
                        coreDataManager.addStreak()
                    }else{
                        // jaraknya lebih dari 1 hari
                        coreDataManager.resetStreak()
                        //tambahin yg baru
                        coreDataManager.addStreak()
                    }
                    
                }
            }
        }
    }
    
    func checkStreakFail(){
        coreDataManager.fetchStreak()
        
        if(coreDataManager.streaks!.count == 0){
            return
        }
        // Get today's beginning & end
        let dateFrom = calendarManager.calendar.startOfDay(for: Date())
        var lastDate = coreDataManager.streaks![coreDataManager.streaks!.count - 1].date
        
        // lastDate!.addTimeInterval(86400)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastDate!, to: dateFrom)
        
        if(components.day! > 1){
            coreDataManager.resetStreak()
        }
    }
}

