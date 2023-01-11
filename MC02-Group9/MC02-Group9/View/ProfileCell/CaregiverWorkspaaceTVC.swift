//
//  CaregiverWorkspaaceTVC.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 17/12/22.
//

import UIKit

class CaregiverWorkspaaceTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var quitLbl: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLbl?.text = listCaregiver.caregiverList[0].name
        quitLbl.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 1)
    }
    
    @IBAction func quitBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Yakin ingin keluar?", message: "Kamu harus meminta izin pasien apabila ingin mengakses kembali.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Keluar", style: .destructive, handler: {
            action in
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
            listCaregiver.caregiverList.removeAll()
            UserDefaults.standard.removeObject(forKey: "patient")
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
}
