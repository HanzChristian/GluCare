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
    
    var name = "Not Loggin (Name)"
    var email = "Not Loggin (Email)"
    var role = -1
    
    private init(){
        
    }
    
    func sendInvitationToPatient(emailPatient: String) -> String{
        var msg = "Invitation can't be sended"
        if  let user = Auth.auth().currentUser?.email{
            print(user)
            self.db.collection("link").addDocument(data: [
                "patient": "\(emailPatient)",
                "caregiver": "",
                "owner": "\(user)",
                "status": false
            ]){ (error) in
                if let e = error {
                    msg = "e \(e)"
                }else{
                    msg = "Invitation send to \(emailPatient)"
                }
            }
        }
        return msg
    }
    
    func sendInvitationToCaregiver(emailCaregiver: String) -> String{
        var msg = "Invitation can't be sended"
        if  let user = Auth.auth().currentUser?.email{
            print(user)
            self.db.collection("link").addDocument(data: [
                "patient": "",
                "caregiver": "\(emailCaregiver)",
                "owner": "\(user)",
                "status": false
            ]){ (error) in
                if let e = error {
                    msg = "e \(e)"
                }else{
                    msg = "Invitation send to \(emailCaregiver)"
                }
            }
        }
        return msg
    }
    
    func getAccountInfo(){
        if let user = Auth.auth().currentUser?.email {
            db.collection("account").whereField("owner", isEqualTo: "\(user)")
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let roleId = data["roleId"] as? Int,
                                let nama = data["nama"] as? String
                            {
                                self!.name = nama
                                self!.email = user
                                if(roleId == 0){
                                    UserDefaults.standard.set(1, forKey: "role")
                                    self!.role = 1
                                }else{
                                    UserDefaults.standard.set(2
                                                              , forKey: "role")
                                    
                                    self!.role = 2
                                }
                            }
                        }
                    }
                }
        }
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
