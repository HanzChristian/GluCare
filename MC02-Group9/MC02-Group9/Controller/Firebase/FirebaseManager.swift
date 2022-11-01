//
//  FirebaseManager.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 01/11/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {
    static let firebaseManager = FirebaseManager()
    let db = Firestore.firestore()
    
    private init(){
        
    }
    
    func loadFirebase() {
        if var user = Auth.auth().currentUser?.email {
            let role = UserDefaults.standard.integer(forKey: "role")
            if role == 2 {
                user = UserDefaults.standard.string(forKey: "patient")!
                print("email fetch \(user)")
            }
            
            
            db.collection("medicine").whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener() { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if let querySnapshot = querySnapshot{
                        let medicine: [MedicineFire] = querySnapshot.documents.compactMap{
                            return try? $0.data(as: MedicineFire.self)
                        }
                        
                        if medicine != nil {
                            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateMedicineFromFirestoreToCoredata(medicines: medicine)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                        }
                    }
                }
            
            db.collection("bg").whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener() { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if let querySnapshot = querySnapshot{
                        let bgs: [BGFire] = querySnapshot.documents.compactMap{
                            return try? $0.data(as: BGFire.self)
                        }
                        
                        if bgs != nil {
                            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateBGFromFirestoreToCoredata(bgs: bgs)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                        }
                    }
                }
            
        
        }
    }
    
    
}
