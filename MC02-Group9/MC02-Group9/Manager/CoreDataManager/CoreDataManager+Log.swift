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
    
    func getLogRealIdx(log: Log) -> Int {
        
        guard let getLogs = logs else{
            return -1
        }
        
        var idx = 0

        for l in getLogs{ //menentukan log bg atau med
            if log.type == l.type && log.time == l.time{
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

    
    
    
}
