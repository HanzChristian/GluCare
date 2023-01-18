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
    @IBOutlet weak var cancelConfirmBtn: UIButton!
    
    let role = UserDefaults.standard.integer(forKey: "role")
    var name = listCaregiver.caregiverList[0].name
    
    @IBAction func tapCancelConfirm(_ sender: UIButton) {
        let alert = UIAlertController(title: "Batalkan Undangan?", message: "Kamu akan membatalkan undangan dari \(name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Batalkan", style: .destructive, handler: {
            action in
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
            listCaregiver.caregiverList.removeAll()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeCaregiver"), object: nil)
        }))
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        let alert = UIAlertController(title: "Batalkan Undangan?", message: "Kamu akan membatalkan undangan untuk \(name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Batalkan", style: .destructive, handler: {
            action in
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
            listCaregiver.caregiverList.removeAll()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeCaregiver"), object: nil)
        }))
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Hapus Akses Anggota?", message: "Kamu akan membatalkan undangan untuk \(name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Keluar", style: .destructive, handler: {
            action in
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
            listCaregiver.caregiverList.removeAll()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeCaregiver"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "connected"), object: nil)
        }))
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func tapConfirm1(_ sender: Any) {
        
        print("button is pressed to confrim")
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
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "connected"), object: nil)
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
        cancelConfirmBtn.isHidden = true
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
        cancelConfirmBtn.isHidden = true
        waitingConfirmBtn.isHidden = true
        deleteCaregiverBtn.isHidden = false
    }
    private func caregiverConfirm(_ bool: Bool) {
        confirmCaregiverBtn.isHidden = false
        cancelConfirmBtn.isHidden = false
        waitingConfirmBtn.isHidden = true
        deleteCaregiverBtn.isHidden = true
    }
    private func caregiverWaiting(_ bool: Bool) {
        confirmCaregiverBtn.isHidden = true
        cancelConfirmBtn.isHidden = true
        waitingConfirmBtn.isHidden = false
        deleteCaregiverBtn.isHidden = true
    }
    
}
