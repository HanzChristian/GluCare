//
//  MigrateFireStoreToCoreData+Log.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 01/11/22.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension MigrateFirestoreToCoreData {
    
    func addNewLogToFirestore(log: Log) {
        if let user = Auth.auth().currentUser?.email{
            let newLog = LogFire(action: log.action!, bg_check_result: log.bg_check_result!, date: log.date!, dateTake: log.dateTake!, log_id: log.log_id!, medicine_name: log.medicine_name!, time: log.time!, type: Int(log.type), owner: user)
            
            do{
                try db.collection("log").document().setData(from: newLog)
                print("success add new Log")
            }catch let error{
                print(" error msg \(error)")
            }
        }
    }
    
    func removeLogToFirestore(id: String) {
        if let user = Auth.auth().currentUser?.email {
            db.collection("log").whereField("log_id", isEqualTo: "\(id)")
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                        }
                    }
                }
        }
    }
    
    func updateLogFirestore(id: String, newLog: Log){
        
        removeLogToFirestore(id: id)
        addNewLogToFirestore(log: newLog)
        
    }
    
    func syncCoredataLogToFirestore(fireLogs: [LogFire]){
        let logs = coreDataManager.fetchAllLogs()
        
        var logsToDelete = [Log]()

        for log in logs {
            
            var findSame = false
            var bgSame = true
            var tempLog: LogFire?
            
            for fireLog in fireLogs {
                if fireLog.log_id == log.log_id{
                    findSame = true
                }
                if fireLog.bg_check_result != log.bg_check_result{
                    bgSame = false
                    tempLog = fireLog
                }
            }
            
            if findSame == false {
                coreDataManager.batalkan(logToRemove: log)
            }
            
            if findSame == true && bgSame == false{
                coreDataManager.updateLog(log: log, logFire: tempLog!)
            }
            
            
        }
    }
    
    func migrateLogFromFirestoreToCoredata(logs: [LogFire]) {
        for log in logs {
            var findSame = false
            // Filter
            let fetch = Log.fetchRequest() as! NSFetchRequest<Log>
            fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Log.log_id), log.log_id)
            do {
                if let m = try context.fetch(fetch).first {
                    print("ada yang sama bro \(m)")
                    findSame = true
                } else {
                    // create new
                }
            }catch {
                
            }
            
            if findSame {
                continue
            }
            
            let newLog = Log(context: context)
            
            newLog.action = log.action
            newLog.bg_check_result = log.bg_check_result
            newLog.date = log.date
            newLog.dateTake = log.dateTake
            newLog.log_id = log.log_id
            newLog.medicine_name = log.medicine_name
            newLog.time = log.time
            newLog.type = Int16(log.type)
            
            do{
                try self.context.save()
            }catch{
                
            }
        }
    }
    
    
}

