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
        var msg = "anjay"
        if  let user = Auth.auth().currentUser?.email{
            print(user)
            
            FirebaseManager.firebaseManager.db.collection("link")
                .whereField("owner", isEqualTo: "\(user)")
                .whereField("patient", isEqualTo: "\(emailPatient)")
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            msg = "You can't invite multiple time"
                        }
                        print("meseg 1\(msg)")
                        if msg != "You can't invite multiple time"{
                            FirebaseManager.firebaseManager.db.collection("link")
                                .whereField("caregiver", isEqualTo: "\(user)")
                                .whereField("owner", isEqualTo: "\(emailPatient)")
                                .getDocuments { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            msg = "You can't invite multiple time"
                                        }
                                        print("meseg 1\(msg)")
                                        if msg != "You can't invite multiple time"{
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
                                        print("meseg 1\(msg)")
                                    }
                                }
                        }
                    }
                }
            
            
        }
        return msg
    }
    
    func sendInvitationToCaregiver(emailCaregiver: String) -> String{
        var msg = "Invitation can't be sended"
        
        
        if  let user = Auth.auth().currentUser?.email{
            print(user)
            
            FirebaseManager.firebaseManager.db.collection("link")
                .whereField("owner", isEqualTo: "\(user)")
                .whereField("caregiver", isEqualTo: "\(emailCaregiver)")
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            msg = "You can't invite multiple time"
                        }
    
                        print("meseg \(msg)")
                        
                        if msg != "You can't invite multiple time"{
                            FirebaseManager.firebaseManager.db.collection("link")
                                .whereField("patient", isEqualTo: "\(user)")
                                .whereField("owner", isEqualTo: "\(emailCaregiver)")
                                .getDocuments { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            msg = "You can't invite multiple time"
                                        }
                                        print("meseg \(msg)")
                                        if msg != "You can't invite multiple time"{
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
                                        print("meseg \(msg)")
                                    }
                                }
                        }
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
                                    self!.loadFirebase()
                                }else{
                                    UserDefaults.standard.set(2
                                                              , forKey: "role")
                                    
                                    self!.role = 2
                                    self!.getUserData()
                                
                                    
                                }
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishGetAccountInfo"),object: nil)
//                                finishGetAccountInfo
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"),object: nil)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
                            }
                        }
                    }
                }
        }
    }
    
    func getUserData(){
        
        if let user = Auth.auth().currentUser?.email {
            db.collection("link")
                .whereField("caregiver", isEqualTo: "\(user)")
                .addSnapshotListener { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let status = data["status"] as? Bool,
                                let owner = data["owner"] as? String,
                                let patient = data["patient"] as? String
                            {
                                if status == true{
                                    if owner.count > 0 {
                                        UserDefaults.standard.set("\(owner)", forKey: "patient")
                                    }else{
                                        UserDefaults.standard.set("\(patient)", forKey: "patient")
                                    }
                                    self!.loadFirebase()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"),object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
                                }
                            }
                        }
                    }
                }
        }
        
        if let user = Auth.auth().currentUser?.email {
            db.collection("link")
                .whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let status = data["status"] as? Bool,
                                let owner = data["owner"] as? String,
                                let patient = data["patient"] as? String
                            {
                                if status == true{
                                    if patient.count > 0 {
                                        UserDefaults.standard.set("\(patient)", forKey: "patient")
                                    }
                                    self!.loadFirebase()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"),object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
                                }
                            }
                        }
                    }
                }
        }
        
        
    }
    
    func loadFirebase() {
        
        var firstTime = false
        
        if var user = Auth.auth().currentUser?.email {
            let role = UserDefaults.standard.integer(forKey: "role")
            if role == 2 {
                if let p = UserDefaults.standard.string(forKey: "patient"){
                    user = p
                }
                
            }
            
            print("email fetch \(user)")
            db.collection("medicine").whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener() { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if let querySnapshot = querySnapshot{
                        let medicine: [MedicineFire] = querySnapshot.documents.compactMap{
                            return try? $0.data(as: MedicineFire.self)
                        }
                        
                        if medicine != nil || firstTime == false{
                            firstTime = true
                            if role == 2{
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateMedicineFromFirestoreToCoredata(medicines: medicine)
                                
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.syncCoredataMedToFirestore(fireMeds: medicine)
                            }
                            
                            
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
                            
                            if role == 2 || firstTime == false{
                                firstTime = true
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateBGFromFirestoreToCoredata(bgs: bgs)
                                
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.syncCoredataBGToFirestore(fireBGs: bgs)
                            }
                            
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                        }
                    }
                }
            
            db.collection("log").whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener() { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if let querySnapshot = querySnapshot{
                        let logs: [LogFire] = querySnapshot.documents.compactMap{
                            return try? $0.data(as: LogFire.self)
                        }
                        
                        if logs != nil || firstTime == false{
                            firstTime == true
                            if role == 2{
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateLogFromFirestoreToCoredata(logs: logs)
                            
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.syncCoredataLogToFirestore(fireLogs: logs)
                            }
                            

                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                        }
                    }
                }
        }
    }
    
    
}
