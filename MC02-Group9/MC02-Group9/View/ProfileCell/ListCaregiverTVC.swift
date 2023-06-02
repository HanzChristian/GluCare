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
    
    let role = RoleHelper.instance.getRole()
    var name = listCaregiver.caregiverList[0].name
    var listCaregiverFirebase = [listCaregiver]()
    
    func filterDeleteCaregiver(newList: [listCaregiver]){
        var count = 0
        let role = RoleHelper.instance.getRole()
        
        for list in listCaregiver.caregiverList{
            var isFound = 0
            
            for j in newList{
                if(list.name == j.name){
                    isFound = 1
                }
            }
            if(isFound == 0){
                listCaregiver.caregiverList.remove(at: count)
                if(role == 2){
                    CoreDataManager.coreDataManager.resetAllCoreData()
                    snapShotListenerList.listenerMed?.remove()
                    snapShotListenerList.listenerBG?.remove()
                    snapShotListenerList.listenerLog?.remove()
                    snapShotListenerList.listenerLog = nil
                    snapShotListenerList.listenerBG = nil
                    snapShotListenerList.listenerMed = nil
                }
            }
            count += 1
        }
    }
    
    //untuk membatalkan undangan dari pihak yang diundang
    @IBAction func tapCancelConfirm(_ sender: UIButton) {
        let alert = UIAlertController(title: "Batalkan Undangan?", message: "Kamu akan membatalkan undangan dari \(name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Batalkan", style: .destructive, handler: {
            action in
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
            self.filterDeleteCaregiver(newList: self.listCaregiverFirebase)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeCaregiver"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disconnected"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "instantConnected"), object: nil)
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
    
    //untuk membatalkan undangan dari pihak yang mengundang
    @IBAction func tapCancel(_ sender: UIButton) {
        let alert = UIAlertController(title: "Batalkan Undangan?", message: "Kamu akan membatalkan undangan untuk \(name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Batalkan", style: .destructive, handler: {
            action in
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
            self.filterDeleteCaregiver(newList: self.listCaregiverFirebase)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeCaregiver"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disconnected"), object: nil)
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
    
    //Menghapus koneksi dari pihak pasien
    @IBAction func tapDelete(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Hapus Akses Anggota?", message: "Kamu akan membatalkan undangan untuk \(name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Keluar", style: .destructive, handler: {
            action in
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
            self.filterDeleteCaregiver(newList: self.listCaregiverFirebase)
    
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "removeCaregiver"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disconnected"), object: nil)
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
    
    //Melakukan konfirmasi undangan
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
                                if self.role == 1{
                                    if let patientId = Auth.auth().currentUser?.uid{
                                        document.reference.updateData([
                                            "status": true,
                                            "patientId": "\(patientId)"
                                        ])
                                    }
                                }else{
                                    document.reference.updateData([
                                        "status": true
                                    ])
                                }
                                
                                
                                
                                FirebaseManager.firebaseManager.getAccountInfo()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "instantConnected"), object: nil)
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
