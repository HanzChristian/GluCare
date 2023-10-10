//
//  MigrateFirestoreToCoreData.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 28/10/22.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MigrateFirestoreToCoreData {
    
    public static let migrateFirestoreToCoreData = MigrateFirestoreToCoreData()
    let coreDataManager = CoreDataManager.coreDataManager
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let notificationCenter = UNUserNotificationCenter.current()
    let db = Firestore.firestore()
    
    private init () {
        
    }
    
    func updateMedFirestore(id: String, medicine: Medicine){
        FirebaseManager.firebaseManager.db.collection("medicine")
            .whereField("id", isEqualTo: "\(id)")
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                    
                        document.reference.updateData([
                            "medicine_eat_time": medicine.eat_time,
                            "medicine_name": medicine.name!
                        ])
                        
//                        let medicine_times = medicine.time!
//                        var new_medicine_times = [MedicineTimeFire]()
//                        for time in medicine_times{
//                            let t = (time as! Medicine_Time).time!
//                            new_medicine_times.append(MedicineTimeFire(time: t))
//                        }
//                        
//                        document.reference.setValue(new_medicine_times, forKey: "medicine_time")
                    }
                }
            }
    }
    
    func removeMedToFirestore(id: String) {
        if let user = Auth.auth().currentUser?.email {
            db.collection("medicine").whereField("id", isEqualTo: "\(id)")
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
    
    func addNewMedToFirestore(medicine: Medicine) {
        let medicine_times = medicine.time!
        var new_medicine_times = [MedicineTimeFire]()
        for time in medicine_times{
            let t = (time as! Medicine_Time).time!
            new_medicine_times.append(MedicineTimeFire(time: t))
        }
        
        if let user = Auth.auth().currentUser{
            let new_medicine = MedicineFire(medicine_name: medicine.name!, medicine_time: new_medicine_times, medicine_eat_time: Int(medicine.eat_time), owner: user.uid, id: medicine.id!, start_date: medicine.start_date!)
            do{
                try db.collection("medicine").document().setData(from: new_medicine)
                print("success add new medicine")
            }catch let error{
                print(" error msg \(error)")
            }
        }
    }
    
    func syncCoredataMedToFirestore(fireMeds: [MedicineFire]){
        
        do {
            let request = Medicine.fetchRequest() as NSFetchRequest<Medicine>
            let meds = try coreDataManager.context.fetch(request)
            
            var logsToDelete = [Log]()

            for med in meds {
                
                var findSame = false
                var bgSame = true
                var tempLog: LogFire?
                
                for fireMed in fireMeds {
                    if fireMed.id == med.id{
                        findSame = true
                    }
                }
                
                if findSame == false {
                    // removing in coredata
                    self.context.delete(med)
                    
                    do{
                        try self.context.save()
                    }catch{
                    }
                }
                
            }
        }catch{
            
        }
    }
    
    func migrateMedicineFromFirestoreToCoredata(medicines: [MedicineFire]) {
        for med in medicines {
            var findSame = false
            // Filter
            let fetch = Medicine.fetchRequest() as! NSFetchRequest<Medicine>
            fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Medicine.id), med.id)
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
            
            let medicine = Medicine(context: context)
            medicine.name = med.medicine_name
            medicine.eat_time = Int16(med.medicine_eat_time)
            medicine.id = med.id
            medicine.start_date = med.start_date
            
            for time in med.medicine_time{
                let medicine_time = Medicine_Time(context: context)
                medicine_time.time = time.time
                medicine.addToTime(medicine_time)
                
            }
            
            do{
                try self.context.save()
            }catch{
                
            }
        }
    }
    
}
