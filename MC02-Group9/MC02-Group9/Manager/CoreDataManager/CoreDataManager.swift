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
    let calendarHelper = CalendarHelper()
    
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
        
        let log = makeLogInit(ref_id: bg.bg_id!)
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
    
    func simpanBG(date: Date, time: String ,bGResult:String, bg_id: String){
        // New
        
        let newLog = makeLogInit(ref_id: bg_id)
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
        
        let log = makeLogInit(ref_id: (self.items![indexPath.row].medicine!.id)!)
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
        
        let log = makeLogInit(ref_id: (self.items![indexPath.row].medicine!.id)!)
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
    
    func bgLog(bgDate:Date,bgTime:String,bg_id:String){
        
        let log = makeLogInit(ref_id: bg_id)
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
        
        let log = makeLogInit(ref_id: (self.items![indexPath.row].medicine!.id)!)
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
    
    func removeAllLogBGAfter(bg: BG, date: Date){

            var logToRemove = [Log]()
            let request = Log.fetchRequest() as NSFetchRequest<Log>

            // Get the current calendar with local time zone
            // Get today's beginning & end
            let dateFrom = calendarManager.calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00

            // Note: Times are printed in UTC. Depending on where you live it won't print 00:00:00 but it will work with UTC times which can be converted to local time

            // Set predicate as date being today's date

            let fromPredicate = NSPredicate(format: "%K >= %@",#keyPath(Log.date), dateFrom as NSDate)
            let typePredicate = NSPredicate(format: "type == 1")
            let timePredicate = NSPredicate(format: "%K == %@",#keyPath(Log.time), bg.bg_time! as String)

            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, typePredicate, timePredicate])

            request.predicate = datePredicate

            do{
                logToRemove = try context.fetch(request)
            }catch{

            }

            print("logtoremove : Date \(date)")

            for log in logToRemove {
                print("logtoremove \(log.log_id!) \(log.date!) \(log.type)")
                removeLogBG(logToRemove: log)
            }

        }

}
