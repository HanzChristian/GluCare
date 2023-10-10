//
//  MigrateFirestoreToCoreData+BG.swift
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
    
    func removeBGToFirestore(id: String) {
        if let user = Auth.auth().currentUser?.email {
            db.collection("bg").whereField("bg_id", isEqualTo: "\(id)")
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
    
    func addNewBGToFirestore(bg: BG) {
        let medicine_times = bg.time!
        var new_medicine_times = [BGTimeFire]()
        for time in medicine_times{
            let t = (time as! BG_Time).bg_date_item
            new_medicine_times.append(BGTimeFire(time: t))
        }
        
        if let user = Auth.auth().currentUser{
            let new_bg = BGFire(bg_id: bg.bg_id!, bg_each_frequency: bg.bg_each_frequency, bg_frequency: bg.bg_frequency, bg_start_date: bg.bg_start_date!, bg_time: bg.bg_time!, bg_type: bg.bg_type, bg_times: new_medicine_times, owner: user.uid)
            do{
                try db.collection("bg").document().setData(from: new_bg)
                print("success add new medicine")
            }catch let error{
                print(" error msg \(error)")
            }
        }
    }
    
    func syncCoredataBGToFirestore(fireBGs: [BGFire]){
        
        do {
            let request = BG.fetchRequest() as NSFetchRequest<BG>
            let bgs = try coreDataManager.context.fetch(request)

            for bg in bgs {
                
                var findSame = false
                
                for fireBG in fireBGs {
                    if fireBG.bg_id == bg.bg_id{
                        findSame = true
                    }
                }
                
                if findSame == false {
                    // removing in coredata
                    self.context.delete(bg)
                    
                    do{
                        try self.context.save()
                    }catch{
                    }
                }
                
            }
        }catch{
            
        }
    }
    
    func migrateBGFromFirestoreToCoredata(bgs: [BGFire]) {
        for bg in bgs {
            var findSame = false
            // Filter
            let fetch = BG.fetchRequest() as! NSFetchRequest<BG>
            fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(BG.bg_id), bg.bg_id)
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
            
            let bloodglucose = BG(context: context)
            
            bloodglucose.bg_each_frequency = Int16(bg.bg_each_frequency)
            bloodglucose.bg_frequency = Int16(bg.bg_frequency)
            bloodglucose.bg_id = bg.bg_id
            bloodglucose.bg_start_date = bg.bg_start_date
            bloodglucose.bg_time = bg.bg_time
            bloodglucose.bg_type = Int16(bg.bg_type)
            
            for time in bg.bg_times{
                let bTimes = BG_Time(context: context)
                bTimes.bg_date_item = time.time
                bloodglucose.addToTime(bTimes)
            }
            
            do{
                try self.context.save()
            }catch{
                
            }
        }
    }
    
}
