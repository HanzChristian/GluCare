//
//  StreakHelper.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 27/06/22.
//

import Foundation
import UIKit

class StreakHelper{
    //singleton
    static let streakHelper = StreakHelper()
    
    //attribute
    var undoIdx = Array(0...100)
    var keTake = Array(0...100)
    
    //helper
    let calendarHelper = CalendarHelper.calendarHelper
    let coreDataHelper = CoreDataHelper.coreDataHelper
    
    private init(){
        
    }
    
    func validateNewStreak(daySelected: Date, tableView: UITableView){
        // check di hari yang sama apa tidak
        let dateNow = calendarHelper.calendar.startOfDay(for: Date())
        let dateCalendar = calendarHelper.calendar.startOfDay(for: daySelected)
        
        if(dateNow != dateCalendar){
            return
        }
        
        coreDataHelper.fetchStreak()
        coreDataHelper.fetchMeds()
        
        coreDataHelper.fetchMedicine(tableView: tableView)
        coreDataHelper.fetchLogs(tableView: tableView, daySelected: daySelected)
        
        let medCount = coreDataHelper.items!.count
        var keTakeCount = 0
        
        print("Ke Take")
        for i in stride(from: 0, to: medCount, by: 1) {
            if(keTake[i] == 1){
                keTakeCount += 1
            }
        }
        
        if(medCount == keTakeCount){
            if(coreDataHelper.streaks!.count == 0){
                // Kondisi ga ada streak
                coreDataHelper.addStreak()
            }else{
                // Kondisi udah ada streak di hari sebelumnya

                // Get today's beginning & end
                let dateFrom = calendarHelper.calendar.startOfDay(for: Date())
                
                var lastDate = coreDataHelper.streaks![coreDataHelper.streaks!.count - 1].date
                
                if(lastDate == dateFrom){
                    print("ADA DI HARI YANG SAMA UDAH KETAMBAH")
                    
                    // Streak nya udah ketambah di hari yg sama
                    return
                }else{
                    // Hitung Jarak Hari nya
                    lastDate!.addTimeInterval(86400)
                    if(lastDate == dateFrom){
                        // Kalau jaraknya 1 hari
                        coreDataHelper.addStreak()
                    }else{
                        // jaraknya lebih dari 1 hari
                        coreDataHelper.resetStreak()
                        //tambahin yg baru
                        coreDataHelper.addStreak()
                    }
                    
                }
            }
        }
    }
    
    func checkStreakFail(){
        coreDataHelper.fetchStreak()
        
        if(coreDataHelper.streaks!.count == 0){
            return
        }
        // Get today's beginning & end
        let dateFrom = calendarHelper.calendar.startOfDay(for: Date())
        var lastDate = coreDataHelper.streaks![coreDataHelper.streaks!.count - 1].date
        
        // lastDate!.addTimeInterval(86400)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastDate!, to: dateFrom)
        
        if(components.day! > 1){
            coreDataHelper.resetStreak()
        }
    }
    
    func resetArray(){
        for i in undoIdx.indices{
            undoIdx[i] = -1
        }
    }
    
    func resetKeTake(){
        for i in keTake.indices{
            keTake[i] = -1
        }
    }
    
}

