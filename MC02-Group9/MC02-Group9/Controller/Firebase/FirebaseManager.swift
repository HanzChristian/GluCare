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
                                                "patientId": "",
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
        
        
        if  let user = Auth.auth().currentUser{
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
                                                "patientId": "\(user.uid)",
                                                "caregiver": "\(emailCaregiver)",
                                                "owner": "\(String(describing: user.email!))",
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
        if let user = Auth.auth().currentUser {
            db.collection("account").whereField("owner", isEqualTo: "\(user.uid)")
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("data heree")
                            let data = document.data()
                            if  let roleId = data["roleId"] as? Int,
                                let nama = data["nama"] as? String
                            {
                                print("nama", nama)
                                self!.name = nama
                                self!.email = user.email!
                                if(roleId == 0){
                                    RoleHelper.instance.setRole(role: .Patient)
                                    self!.role = 1
                                    self!.loadFirebase({_,_,_ in
                                        
                                    })
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
                                let patient = data["patient"] as? String,
                                let userId = data["patientId"] as? String
                            {
                                if status == true{
     
                                    UserDefaults.standard.set("\(userId)", forKey: "patient")
                                    if snapShotListenerList.listenerLog == nil || snapShotListenerList.listenerBG == nil ||
                                        snapShotListenerList.listenerMed == nil {
                                        self!.loadFirebase({_,_,_ in
                                            
                                        })
                                    }

                                
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"),object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "connected"), object: nil)
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
                                let patient = data["patient"] as? String,
                                let userId = data["patientId"] as? String
                            {
                                if status == true{
                                    
                                    UserDefaults.standard.set("\(userId)", forKey: "patient")
                                    
                                    if snapShotListenerList.listenerLog == nil || snapShotListenerList.listenerBG == nil ||
                                        snapShotListenerList.listenerMed == nil {
                                        self!.loadFirebase({_,_,_ in
                                            
                                        })
                                    }
                                   
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"),object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "connected"), object: nil)
                                }
                            }
                        }
                    }
                }
        }
        
        
    }
    
    func loadFirebase(_ completion: (ListenerRegistration,ListenerRegistration,ListenerRegistration) -> Void){
        
        var firstTime = false
        var firstTime2 = false
        var firstTime3 = false
        
        if var user = Auth.auth().currentUser?.uid {
            let role = RoleHelper.instance.getRole()
            if role == 2 {
                if let p = UserDefaults.standard.string(forKey: "patient"){
                    user = p
                    print("DEBUG: -- \(p)")
                }
                
            }
            
            print("userid \(user)")
            
            print("email fetch \(user)")
            let listenerMed = db.collection("medicine").whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener() { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if let querySnapshot = querySnapshot{
                        let medicine: [MedicineFire] = querySnapshot.documents.compactMap{
                            return try? $0.data(as: MedicineFire.self)
                        }
                        
                        if medicine != nil {
                            
                            if role == 2 || firstTime == false{
                                firstTime = true
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateMedicineFromFirestoreToCoredata(medicines: medicine)
                                
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.syncCoredataMedToFirestore(fireMeds: medicine)
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                            }
                            
                        }
                    }
                }
        
            
            
            
           let listenerBG = db.collection("bg").whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener() { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if let querySnapshot = querySnapshot{
                        let bgs: [BGFire] = querySnapshot.documents.compactMap{
                            return try? $0.data(as: BGFire.self)
                        }
                        
                        if bgs != nil {
                            
                            if role == 2 || firstTime2 == false{
                                firstTime2 = true
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateBGFromFirestoreToCoredata(bgs: bgs)
                                
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.syncCoredataBGToFirestore(fireBGs: bgs)
                                
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                            }
                            
                     
                        }
                    }
                }
            
            let listenerLog = db.collection("log").whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener() { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else if let querySnapshot = querySnapshot{
                        let logs: [LogFire] = querySnapshot.documents.compactMap{
                            return try? $0.data(as: LogFire.self)
                        }
                        
                        if logs != nil {
                            
                            if role == 2 || firstTime3 == false{
                                firstTime3 = true
                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateLogFromFirestoreToCoredata(logs: logs)

                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.syncCoredataLogToFirestore(fireLogs: logs)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                            }
                            
//                            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateLogFromFirestoreToCoredata(logs: logs)
//
//                            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.syncCoredataLogToFirestore(fireLogs: logs)
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
                        }
                    }
                }
            snapShotListenerList.listenerBG = listenerBG
            snapShotListenerList.listenerMed = listenerMed
            snapShotListenerList.listenerLog = listenerLog
            
            print("listener log = \(listenerLog) \(user)b")
//            listenerLog.remove()
            completion (listenerMed,listenerBG,listenerLog)
            
//            db.collection("link").whereField("owner", isEqualTo: "\(user)")
//                .addSnapshotListener() { [weak self] (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                    } else if let querySnapshot = querySnapshot{
//                        let logs: [LogFire] = querySnapshot.documents.compactMap{
//                            return try? $0.data(as: LogFire.self)
//                        }
//
//                        if logs != nil {
//
//                            if role == 2 || firstTime3 == false{
//                                firstTime3 = true
//                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.migrateLogFromFirestoreToCoredata(logs: logs)
//
//                                MigrateFirestoreToCoreData.migrateFirestoreToCoreData.syncCoredataLogToFirestore(fireLogs: logs)
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
//                            }
//
//                        }
//                    }
//                }

        }
    }
    
    
}
