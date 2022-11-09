//
//  coreDataManager.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 27/06/22.
//

import Foundation
import CoreData
import UIKit
import RxSwift
import RxCocoa

class CoreDataManager{
    //singleton
    static let coreDataManager = CoreDataManager()
    
    //Rx
    var jadwal = BehaviorRelay<[JadwalVars]>(value: [])
    
    //attribute
    var undoIdx = Array(0...100)
    var keTake = Array(0...100)
    
    //attriute
    var items:[Medicine_Time]?
    var logs:[Log]?
    var streaks:[Streak]?
    var medicines:[Medicine]?
    var bg:[BG]?
    var bgTime:[BG_Time]?
    var user:[User]?
    
    //takemed attribute
    var medicineSelectedIdx = 0
    
    //context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //helper
    let calendarManager = CalendarManager.calendarManager
    
    private init(){
        
    }
    
    func resetAllCoreData() {

         // get all entities and loop over them
         let entityNames = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel.entities.map({ $0.name!})
         entityNames.forEach { [weak self] entityName in
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

            do {
                try self?.context.execute(deleteRequest)
                try self?.context.save()
            } catch {
                // error
            }
        }
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
    
//    func saveUser(user_role:Int16){
//        let user = User(context: self.context)
//        user.user_role = user_role
//
//        userRoles.userRole = Int(user.user_role)
//
//        do{
//            try self.context.save()
//        }catch{
//
//        }
//    }
    
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
    
    func makeLogInit() -> Log {
        
        let newLog = Log(context: self.context)
        newLog.action = ""
        newLog.bg_check_result = "-1"
        newLog.date = Date()
        newLog.dateTake = Date()
        newLog.log_id = UUID().uuidString
        newLog.medicine_name = ""
        newLog.time = ""
        newLog.type = 0 //med
        
        
        
        return newLog
        
    }
    
    func lewatBG(daySelected: Date,bGResult:String,bg:BG){
        //change daySelected to String
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "dd MMM yyyy"
        let tanggal = formatter.string(from: daySelected)
        // print(tanggal)
        
        // Create String
        let time = bg.bg_time!
        let hour = time[..<time.index(time.startIndex, offsetBy: 2)]
        let minutes = time[time.index(time.startIndex, offsetBy: 3)...]
        let string = ("\(tanggal) \(hour):\(minutes):00 +0700")
        print(string)
        // 29 October 2019 20:15:55 +0200

        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        // Convert String to Date
        print("\(dateFormatter.date(from: string)!) ubah ke UTC")
        
        let log = makeLogInit()
        log.date = dateFormatter.date(from: string)
        log.dateTake = dateFormatter.date(from: string)
        log.action = "Skip"
        log.bg_check_result = bGResult
        log.type = 1
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        //Firestore
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewLogToFirestore(log: log)
    }
    
    func simpanBG(date: Date, time: String ,bGResult:String){
        // New
        
        let newLog = makeLogInit()
        newLog.date = date
        newLog.time = time
        newLog.bg_check_result = bGResult
        newLog.type = 1
        newLog.action = "Take"
        
        
        print("log baru \(newLog.bg_check_result!)")
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        //Firestore
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewLogToFirestore(log: newLog)
    }
    
    func lewati(daySelected: Date, indexPath: IndexPath){
        //change daySelected to String
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "dd MMM yyyy"
        let tanggal = formatter.string(from: daySelected)
        // print(tanggal)
        
        // Create String
        let time = self.items![indexPath.row].time!
        let hour = time[..<time.index(time.startIndex, offsetBy: 2)]
        let minutes = time[time.index(time.startIndex, offsetBy: 3)...]
        let string = ("\(tanggal) \(hour):\(minutes):00 +0700")
        print(string)
        // 29 October 2019 20:15:55 +0200

        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        // Convert String to Date
        print("\(dateFormatter.date(from: string)!) ubah ke UTC")
        
        let log = makeLogInit()
        log.date = dateFormatter.date(from: string) // Oct 29, 2019 at 7:15 PM
        log.dateTake = dateFormatter.date(from: string)
        log.action = "Skip"
        log.time = self.items![indexPath.row].time
        log.medicine_name = self.items![indexPath.row].medicine?.name
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        //Firestore
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewLogToFirestore(log: log)
    }
    
    func pilihWaktu(daySelected: Date, indexPath: IndexPath, myDatePicker: UIDatePicker){
        
        //change daySelected to String
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "dd MMM yyyy"
        let tanggal = formatter.string(from: daySelected)
        // print(tanggal)
        
        // Create String
        let times = self.items![indexPath.row].time!
        let hour = times[..<times.index(times.startIndex, offsetBy: 2)]
        let minutes = times[times.index(times.startIndex, offsetBy: 3)...]
        let string = ("\(tanggal) \(hour):\(minutes):00 +0700")
        print(string)
        // 29 October 2019 20:15:55 +0200

        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        // Convert String to Date
        print("\(dateFormatter.date(from: string)!) ubah ke UTC")
        
        let time = myDatePicker.date
        // change to ICT by time interval
        // time.addTimeInterval(25200)
        print("Selected Date: \(time)")
        
        let log = makeLogInit()
        log.date = dateFormatter.date(from: string) // Oct 29, 2019 at 7:15 PM
        log.dateTake = time
        log.action = "Take"
        log.time = self.items![indexPath.row].time
        log.medicine_name = self.items![indexPath.row].medicine?.name
        
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        //Firestore
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewLogToFirestore(log: log)
    }
    
    func bgLog(bgDate:Date,bgTime:String){
        
        let log = makeLogInit()
        log.date = bgDate
        log.time = bgTime
        log.bg_check_result = "-1"
        log.type = 1
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        //Firestore
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewLogToFirestore(log: log)
    }
    
    func checkBG(daySelected: Date, indexPath: IndexPath){
        //change daySelected to String
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "dd MMM yyyy"
        let tanggal = formatter.string(from: daySelected)
        // print(tanggal)
        
        // Create String
        let time = self.items![indexPath.row].time!
        let hour = time[..<time.index(time.startIndex, offsetBy: 2)]
        let minutes = time[time.index(time.startIndex, offsetBy: 3)...]
        let string = ("\(tanggal) \(hour):\(minutes):00 +0700")
        print(string)
        // 29 October 2019 20:15:55 +0200

        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        // Convert String to Date
        print("\(dateFormatter.date(from: string)!) ubah ke UTC")
        
        let bg_time = BG_Time(context: self.context)
        
    }
    
    func tepatWaktu(daySelected: Date, indexPath: IndexPath){
        //change daySelected to String
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_gb")
        formatter.dateFormat = "dd MMM yyyy"
        let tanggal = formatter.string(from: daySelected)
        // print(tanggal)
        
        // Create String
        let time = self.items![indexPath.row].time!
        let hour = time[..<time.index(time.startIndex, offsetBy: 2)]
        let minutes = time[time.index(time.startIndex, offsetBy: 3)...]
        let string = ("\(tanggal) \(hour):\(minutes):00 +0700")
        print(string)
        // 29 October 2019 20:15:55 +0200

        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss Z"
        // Convert String to Date
        print("\(dateFormatter.date(from: string)!) ubah ke UTC")
        
        let log = makeLogInit()
        log.date = dateFormatter.date(from: string) // Oct 29, 2019 at 7:15 PM
        log.dateTake = dateFormatter.date(from: string)
        log.action = "Take"
        log.time = self.items![indexPath.row].time
        log.medicine_name = self.items![indexPath.row].medicine?.name
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        //Firestore
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.addNewLogToFirestore(log: log)
    }
    
    func fetchBG(){
        do{
            let request = BG.fetchRequest() as NSFetchRequest<BG>
            
            let sort = NSSortDescriptor(key: "bg_time", ascending: true)
            request.sortDescriptors = [sort]
            
            self.bg = try context.fetch(request)
            
        }catch{
            
        }
    }
    
//    func fetchUser(){
//        do{
//            let request = User.fetchRequest() as NSFetchRequest<User>
//
//            self.user = try context.fetch(request)
//
//        }catch{
//
//        }
//    }
    
    func fetchBGTime(daySelected:Date){
        let f = DateFormatter()

        do{
            let request = BG_Time.fetchRequest() as NSFetchRequest<BG_Time>
            
            self.bgTime = try context.fetch(request)
            
        }catch{
            
        }
    }
    
    func fetchMeds(){
        do{
            let request = Medicine.fetchRequest() as NSFetchRequest<Medicine>
            
            self.medicines = try context.fetch(request)
    
        }catch{
            
        }
    }
    
    func fetchStreak(){
        do{
            let request = Streak.fetchRequest() as NSFetchRequest<Streak>
            
            self.streaks = try context.fetch(request)
            
        }catch{
            
        }
    }
    
    func fetchMedicine(tableView: UITableView){
        do{
            let request = Medicine_Time.fetchRequest() as NSFetchRequest<Medicine_Time>
            
            let sort = NSSortDescriptor(key: "time", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }catch{
            
        }
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
    
    func fetchDateBG(){
        
        let request = BG.fetchRequest() as NSFetchRequest<BG>
        
        // Get the current calendar with local time zone

        // Get today's beginning & end
        let dateFrom = calendarManager.calendar.startOfDay(for: daySelected) // eg. 2016-10-10 00:00:00
        let dateTo = calendarManager.calendar.date(byAdding: .day, value: 1, to: dateFrom)
        

        // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "%@ <= %K", dateFrom as NSDate, #keyPath(BG.bg_start_date))

        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(BG.bg_start_date), dateTo! as NSDate)
                                        
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
    }
    
    func resetStreak(){
        // reset streak
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Streak")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newStreak"), object: nil)
    }
    
    func addStreak(){
        // Get today's beginning & end
        let dateFrom = calendarManager.calendar.startOfDay(for: Date())
        let streak = Streak(context: context)
        streak.date = dateFrom
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newStreak"), object: nil)
    }

    func removeStreak(streakToRemove: Streak){
        // streak
        self.context.delete(streakToRemove)
        
        do{
            try self.context.save()
        }catch{
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newStreak"), object: nil)
    }

    func dummyData(){
        // create medicine
        let medicine = Medicine(context: context)
        medicine.name = "Panadol"
        medicine.eat_time = 1
        
        // Add time
        let medicine_time1 = Medicine_Time(context: context)
        medicine_time1.time = "07.00"
        
        let medicine_time2 = Medicine_Time(context: context)
        medicine_time2.time = "12.00"
        
        let medicine_time3 = Medicine_Time(context: context)
        medicine_time3.time = "18.00"
        
        // Add Time to Medicine
        medicine.addToTime(medicine_time1)
        medicine.addToTime(medicine_time2)
        medicine.addToTime(medicine_time3)
        
        do{
            try self.context.save()
        }catch{
            
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
