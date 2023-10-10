//
//  profileViewController+Firebase.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 07/11/22.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


extension ProfileViewController{
    
    func filterNewCaregiver(newList: listCaregiver) -> Bool{
        var i = 0
        for list in listCaregiver.caregiverList{
            if newList.name == list.name{
                listCaregiver.caregiverList[i].status = newList.status
                return true
            }
            
            
            i += 1
        }
        
        return false
    }
    
    func getRole() {
        if let user = Auth.auth().currentUser?.uid {
            
            print("DEBUG: \(user) GETROLE")
            FirebaseManager.firebaseManager.db.collection("account").whereField("owner", isEqualTo: "\(user)")
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let roleId = data["roleId"] as? Int{
                                
                                if(roleId == 0){
                                    RoleHelper.instance.setRole(role: .Patient)
                                }else{
                                    RoleHelper.instance.setRole(role: .Caregiver)
                                }
                                self!.fetchInvitationFromCaregiver()
                            }
                        }
                    }
                }
        }
    }

    func fetchInvitationFromCaregiver() {
        
        
        print("fetchInvitationFromCaregiver ")
        if UserDefaults.standard.value(forKey: "role") == nil{
            print("DEBUG: GAADA USERDEFAULTNYA")
            return
        }
        
        let role = RoleHelper.instance.getRole()
        var roleString = ""
        var role2String = ""
        
        if role == 1{
            roleString = "patient"
            role2String = "caregiver"
        }else if role == 2{
            roleString = "caregiver"
            role2String = "patient"
        }
        
        // gw yg dikirim
        print("DEBUG: \(roleString)")
        
        if let user = Auth.auth().currentUser?.email {
            print("DEBUG: GW YG DIKIRIM \(roleString) \(user)")
            FirebaseManager.firebaseManager.db.collection("link")
                .whereField(roleString, isEqualTo: "\(user)")
                .addSnapshotListener { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var listCaregiverFirebase = [listCaregiver]()
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let caregiver = data["owner"] as? String,
                                let status = data["status"] as? Bool
                            {
                                print("sini bang 1\(caregiver)")
                                var s = -1
                                if status == false{
                                    s = 1
                                }else if status == true{
                                    s = 0
                                }
                                
                                let newList = listCaregiver(name: caregiver, status: s)
                                
                                listCaregiverFirebase.append(newList)
                                
                                if(self!.filterNewCaregiver(newList: newList) == false){
                                    listCaregiver.caregiverList.append(newList)
                                }
                                
                            }
                        }
//                        self!.filterDeleteCaregiver(newList: listCaregiverFirebase)
                        self?.tableView.reloadData()
                        if querySnapshot!.isEmpty{

                        }
                    }
                }
            
            // gw yg kirim
            FirebaseManager.firebaseManager.db.collection("link")
                .whereField("owner", isEqualTo: "\(user)")
                .addSnapshotListener { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var listCaregiverFirebase = [listCaregiver]()
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if  let caregiver = data["\(role2String)"] as? String,
                                let status = data["status"] as? Bool
                            {
                                print("sini bang 1\(caregiver)")
                                var s = -1
                                if status == false{
                                    s = 2
                                }else if status == true{
                                    s = 0
                                }
                                print("\(caregiver)")
                                
                                let newList = listCaregiver(name: caregiver, status: s)
                                listCaregiverFirebase.append(newList)
                                if(self!.filterNewCaregiver(newList: newList) == false){
                                    listCaregiver.caregiverList.append(newList)
                                }
                            }
                        }
//                        self!.filterDeleteCaregiver(newList: listCaregiverFirebase)
                        self?.tableView.reloadData()
                        if querySnapshot!.isEmpty{

                        }
                    }
                }
        }
    }
    
}