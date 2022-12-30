//
//  ListCaregiverTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 03/11/22.
//

import UIKit
import Firebase

class ListCaregiverTVC: UITableViewCell {
    
    @IBOutlet weak var caregiverNameLbl: UILabel!
    @IBOutlet weak var confirmCaregiverBtn: UIButton!
    @IBOutlet weak var waitingConfirmBtn: UIButton!
    @IBOutlet weak var deleteCaregiverBtn: UIButton!
    
    
    @IBAction func tapCancel(_ sender: UIButton) {
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
        listCaregiver.caregiverList.removeAll()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeCaregiver"), object: nil)
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        
        MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
        listCaregiver.caregiverList.removeAll()
    }
    
    @IBAction func tapConfirm1(_ sender: Any) {
        
        print("button is pressed to confrim")
        
        let role = UserDefaults.standard.integer(forKey: "role")
        var roleString = ""
        
        if role == 1{
            roleString = "patient"
        }else if role == 2{
            roleString = "caregiver"
            waitingConfirmBtn.titleLabel?.text = "Batalkan Permohonan"
        }
        
        if let user = Auth.auth().currentUser?.email {
            
            FirebaseManager.firebaseManager.db.collection("link")
                .whereField("owner", isEqualTo: "\(temp!.name)")
                .whereField(roleString, isEqualTo: "\(user)")
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            
                            let data = document.data()
                            if  let caregiver = data["owner"] as? String
                            {
                                document.reference.updateData([
                                    "status": true
                                ])
                                
                                FirebaseManager.firebaseManager.getAccountInfo()
                            }
                        }
                        
                    }
                }
        }
    }
    
    var temp: listCaregiver?
    
    func setupView(care: listCaregiver){
        temp = care
        caregiverNameLbl?.text = care.name
        let caregiverStatus = care.status
        
        if (caregiverStatus == 0) {
            caregiver(true)
        } else if (caregiverStatus == 1) {
            caregiverConfirm(true)
        } else if (caregiverStatus == 2) {
            caregiverWaiting(true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    // TINGGAL DIMAININ IS HIDDEN NYA
        confirmCaregiverBtn.isHidden = true
        waitingConfirmBtn.isHidden = true
        deleteCaregiverBtn.isHidden = false
//        STATUS CAREGIVER
//        0 = SUDAH ACCEPT
//        1 = BUTTON KONFIRMASI
//        2 = MENUNGGU KONFIRMASI
        
//
//        if (caregiverStatus == 0) {
//            caregiver(true)
//        } else if (caregiverStatus == 1) {
//            caregiverConfirm(true)
//        } else if (caregiverStatus == 2) {
//            caregiverWaiting(true)
//        }
//
        
        // Initialization code
    }
}

extension ListCaregiverTVC {
    private func caregiver(_ bool: Bool) {
        confirmCaregiverBtn.isHidden = true
        waitingConfirmBtn.isHidden = true
        deleteCaregiverBtn.isHidden = false
    }
    private func caregiverConfirm(_ bool: Bool) {
        confirmCaregiverBtn.isHidden = false
        waitingConfirmBtn.isHidden = true
        deleteCaregiverBtn.isHidden = true
    }
    private func caregiverWaiting(_ bool: Bool) {
        confirmCaregiverBtn.isHidden = true
        waitingConfirmBtn.isHidden = false
        deleteCaregiverBtn.isHidden = true
    }
    
}
