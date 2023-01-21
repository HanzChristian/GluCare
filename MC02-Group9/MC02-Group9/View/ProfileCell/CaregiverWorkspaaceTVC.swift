//
//  CaregiverWorkspaaceTVC.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 17/12/22.
//

import UIKit

class CaregiverWorkspaaceTVC: UITableViewCell {

    @IBOutlet weak var quitLbl: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    var namaPasien = listCaregiver.caregiverList[0].name
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLbl?.text = "Kamu berada di dalam workspace \(namaPasien)"
        quitLbl.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 1)
        tempNama.name = namaPasien
        
    }
    
//    @objc func toJadwal(){
//        let storyboard = UIStoryboard(name: "viewController", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
////        let navController = UINavigationController(rootViewController: vc)
//
//        vc.navigationController?.pushViewController(vc, animated: true)
//        vc.modalPresentationStyle = .fullScreen
//
//        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
//        if let navigationController = rootViewController as? UINavigationController {
//            rootViewController = navigationController.viewControllers.first
//        }
//        if let tabBarController = rootViewController as? UITabBarController {
//            rootViewController = tabBarController.selectedViewController
//        }
//        rootViewController?.present(vc, animated: true, completion: nil)
//
//    }
    
    
    @IBAction func quitBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Yakin ingin keluar?", message: "Kamu harus meminta izin pasien apabila ingin mengakses kembali.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Keluar", style: .destructive, handler: { [self]
            action in
            print("listener log removed= \(snapShotListenerList.listenerLog)")
            snapShotListenerList.listenerMed?.remove()
            snapShotListenerList.listenerBG?.remove()
            snapShotListenerList.listenerLog?.remove()
            snapShotListenerList.listenerLog = nil
            snapShotListenerList.listenerBG = nil
            snapShotListenerList.listenerMed = nil
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.removeConnection()
            listCaregiver.caregiverList.removeAll()
            UserDefaults.standard.removeObject(forKey: "patient")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "connected"), object: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passJadwal"), object: nil)
            
            
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

struct tempNama{
    static var name = ""
}
