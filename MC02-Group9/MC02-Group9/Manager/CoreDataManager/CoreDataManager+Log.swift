//
//  CoreDataManager+Log.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 11/11/22.
//

import Foundation
import CoreData
import UIKit

extension CoreDataManager{
    
    func makeLogInit(ref_id: String) -> Log {
        
        let newLog = Log(context: self.context)
        newLog.action = ""
        newLog.bg_check_result = "-1"
        newLog.date = Date()
        newLog.dateTake = Date()
        newLog.log_id = UUID().uuidString
        newLog.medicine_name = ""
        newLog.time = ""
        newLog.type = 0 //med
        newLog.eat_time = -1
        newLog.ref_id = ref_id
        
        
        return newLog
        
    }
    
    func updateLog(log: Log, logFire:LogFire){
        log.bg_check_result = logFire.bg_check_result
        log.action = logFire.action
        
        do{
            try self.context.save()
        }
        catch {
            
        }
        
    }
    
    func batalkan(logToRemove: Log){
        if logToRemove.type == 1 {
            // BG Logic
//            logToRemove.bg_check_result = "-1"
            do{
                try self.context.save()
            }
            catch {

            }

            return
        }
        
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeLogToFirestore(id: logToRemove.log_id!)
        
        // remove log
        self.context.delete(logToRemove)
        
        do{
            try self.context.save()
        }catch{
            
        }
        
    }
    
    func removeLogBG(logToRemove: Log){
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeLogToFirestore(id: logToRemove.log_id!)
        
        // remove log
        self.context.delete(logToRemove)
        
        do{
            try self.context.save()
        }catch{
            
        }
    }
    
    func getLogRealIdx(med: Medicine_Time) -> Int {
        
        guard let getLogs = logs else{
            return -1
        }
        
        var idx = 0

        for l in getLogs{ //menentukan log bg atau med
            if l.type == 0 && med.time == l.time && med.medicine!.name == l.medicine_name {
                return idx
            }
            
            idx += 1
        }
        
        return -1
    }
    
    func getLogRealIdx(log: Log, bg: BG) -> Int {
        
        guard let getLogs = logs else{
            return -1
        }
        
        var idx = 0

        for l in getLogs{ //menentukan log bg atau med
            if bg.bg_id == l.ref_id{
                return idx
            }
            
            idx += 1
        }
        
        return -1
    }
    
    func fetchAllLogs() -> [Log]{
        
        do {
            let request = Log.fetchRequest() as NSFetchRequest<Log>
            let logs = try context.fetch(request)
            
            return logs
        }catch{
            
            
        }
        
        return [Log]()
    }
    
    func fetchLogs(tableView: UITableView, daySelected: Date){
        do{
            resetArray()
            logs?.removeAll()
            let request = Log.fetchRequest() as NSFetchRequest<Log>
            
            // Get the current calendar with local time zone

            // Get today's beginning & end
            let dateFrom = calendarManager.calendar.startOfDay(for: daySelected) // eg. 2016-10-10 00:00:00
            let dateTo = calendarManager.calendar.date(byAdding: .day, value: 1, to: dateFrom)

            // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

            // Set predicate as date being today's date
            let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(Log.date))
            
            let toPredicate = NSPredicate(format: "%K < %@", #keyPath(Log.date), dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            
            request.predicate = datePredicate
            
            let sort = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [sort]
            
            self.logs = try context.fetch(request)
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
            /*
            //test
            for (index, log) in self.logs!.enumerated() {
                print("\(index): \(log.medicine_name) \(log.date) ")
                
            }
            
            //end test
             */
        }catch{
            
        }
    }
    
    func checkMedLogAvailable(logs: [Log], meds: [Medicine], dayselected: Date){
        for med in meds {
            
            let today = calendarManager.calendar.startOfDay(for: dayselected)
            let medDate = calendarManager.calendar.startOfDay(for: med.start_date!)
            
            print("aku ga bikin \(today) \(medDate)")
            
            if today < medDate{
                print("aku ga bikin")
                continue
            }
            
            var isLog = false
            
            for log in logs {
                if med.id == log.ref_id{
                    isLog = true
                }
            }
            
            if isLog == false {
                // Buat log baru
                let med_times = med.time
                for t in med_times!{
                    let time = t as! Medicine_Time
                    print("create at time \(time.time)")
                    medLog(medicine_name: med.name!, date: dayselected, time: time.time!, bg_id: med.id!, eat_time: med.eat_time)
                }
            }
        }
    }
    
    
    func checkBGLogAvailable(logs: [Log], bgs: [BG], daySelected: Date){
        for bg in bgs {
            var isLog = false
            
            for log in logs {
                if bg.bg_id == log.ref_id{
                    isLog = true
                }
            }
            
            if isLog == false {
                populateBGLog(bg: bg, daySelected: daySelected)
            }
        }
    }
    
    func populateBGLog(bg: BG, daySelected: Date){
        let logs = getLogBGWithSameRefID(bg: bg)
        
        print("tes69 -- masuk")
        if logs.count == 0 {
            return
        }
        var beginDate = logs.last!.date!
        beginDate = calendarManager.calendar.startOfDay(for: beginDate)
        
        if bg.bg_frequency == 0{
            // Hari
        
            // beginDate + setiap
            beginDate = CalendarManager.calendarManager.calendar.date(byAdding: .day, value: Int(bg.bg_each_frequency), to: beginDate)!
            populateLogBGHari(bg: bg, beginDate: beginDate , untilDate: daySelected)
        }else if bg.bg_frequency == 1{
            // Minggu
            
            guard let bg_times = bg.time else{
                return
            }
            /*
            The date component weekday is a Int value: 1...7 starting with sunday.
            sunday = 1
            monday = 2
            tuesday = 3
            wednesday = 4
            thursday = 5
            friday = 6
            saturday = 7
            
            */
            var maxWeekday = -100
            var minWeekday = 100
            for bg_time in bg_times {
                let currentWeekDay = (bg_time as! BG_Time).bg_date_item
                if currentWeekDay == 1 {
                    maxWeekday = Int(currentWeekDay + 7)
                }

                if maxWeekday < currentWeekDay{
                    maxWeekday = Int(currentWeekDay)
                }

                if minWeekday > currentWeekDay{
                    minWeekday = Int(currentWeekDay)
                }
            }

            let compareWeekday = maxWeekday - minWeekday
            
            beginDate = calendarHelper.addDays(date: beginDate, days: 7*Int(bg.bg_each_frequency))
            beginDate = calendarHelper.addDays(date: beginDate, days: -compareWeekday)
            
            populateLogBGMinggu(bg: bg, beginDate: beginDate, untilDate: daySelected)
            
        }else if bg.bg_frequency == 2{
            // Bulan
        }
        
    }

    func getLogBGWithSameRefID(bg: BG) -> [Log]{
        // Filter
        var logs = [Log]()
        let fetch = Log.fetchRequest() as! NSFetchRequest<Log>
        fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Log.ref_id), bg.bg_id!)
        let sort = NSSortDescriptor(key: #keyPath(Log.date), ascending: true)
        fetch.sortDescriptors = [sort]
        
        
        do {
            logs =  try context.fetch(fetch)
        }catch {
            
        }
        
        return logs
    }
    
    func populateLogBGHari(bg: BG, beginDate:Date, untilDate: Date){
        var lastDate = beginDate
        
        repeat {
            CoreDataManager.coreDataManager.bgLog(bgDate: lastDate, bgTime: bg.bg_time!, bg_id: bg.bg_id!, bg_type: bg.bg_type)
            
            let date = CalendarManager.calendarManager.calendar.date(byAdding: .day, value: Int(bg.bg_each_frequency), to: lastDate)
            lastDate = date!
            
        } while lastDate < untilDate
    }
    
    func populateLogBGMinggu(bg: BG, beginDate:Date, untilDate: Date){
        var lastDate = beginDate
        
        guard let bg_times = bg.time else{
            return
        }
        
        while lastDate < untilDate{
            let oneWeekAgo = calendarHelper.addDays(date: lastDate, days: 7)
            var currentDate = lastDate
            
            while(currentDate < oneWeekAgo){
                let currentWeekDay = calendarHelper.calendar.dateComponents([.weekday], from: currentDate).weekday!
                
                for t in bg_times{
                    if(currentWeekDay == (t as! BG_Time).bg_date_item){
                        
                        let isSameBGLog = isSameBGLog(currentDate: currentDate, bgTime: bg.bg_time!, bg_id: bg.bg_id!)
                        
                        if isSameBGLog == 1{
                            continue
                        }
                        
                        CoreDataManager.coreDataManager.bgLog(bgDate: currentDate, bgTime: bg.bg_time!, bg_id: bg.bg_id!,bg_type: bg.bg_type)
                        
                        print(" CURRENT DATE \(currentDate) \(currentWeekDay)")
                        print("Tete \((t as! BG_Time).bg_date_item)")
                        
                    }
                }
                print(" CURRENT WEEK \(currentDate) \(currentWeekDay)")
            
                currentDate = calendarHelper.addDays(date: currentDate, days: 1)
            }

            lastDate = calendarHelper.addDays(date: lastDate, days: 7*Int(bg.bg_each_frequency))
        }
        
        
    }
    
    func isSameBGLog(currentDate: Date, bgTime: String, bg_id: String) -> Int{
        let request = Log.fetchRequest() as NSFetchRequest<Log>
        var logToRemove = [Log]()
        
        // Get the current calendar with local time zone
        // Get today's beginning & end
        let dateFrom = calendarManager.calendar.startOfDay(for: currentDate) // eg. 2016-10-10
        let fromPredicate = NSPredicate(format: "%K == %@",#keyPath(Log.date), dateFrom as NSDate)
        let typePredicate = NSPredicate(format: "type == 1")
        let timePredicate = NSPredicate(format: "%K == %@",#keyPath(Log.time), bgTime as String)
        let bgIdPredicate = NSPredicate(format: "%K == %@",#keyPath(Log.ref_id), bg_id as String)

        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, typePredicate, timePredicate, bgIdPredicate])

        request.predicate = datePredicate

        do{
            logToRemove = try context.fetch(request)
        }catch{

        }
        
        if logToRemove.count == 0{
            return 0
        }
        return 1
    }

    
    
    
}
