//
//  ViewController+Sheet.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 16/02/23.
//

import UIKit

extension ViewController {
    private func showActionSheet(indexPath: IndexPath) {
        let alert = UIAlertController(title: "", message: "Kapan kamu mengonsumsi obat ini?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Tepat Waktu", style: .default, handler: { action in
            self.coreDataManager.tepatWaktu(daySelected: daySelected, log: self.coreDataManager.logs![indexPath.row])
            
            self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
            
            self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Pilih Waktu", style: .default, handler: { action in
            self.dismiss(animated: true, completion: {
                let myDatePicker: UIDatePicker = UIDatePicker()
                myDatePicker.preferredDatePickerStyle = .wheels
                myDatePicker.timeZone = TimeZone.init(identifier: "ICT")
                myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
                let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
                
                alertController.view.addSubview(myDatePicker)
                
                let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    
                    self.coreDataManager.pilihWaktu(daySelected: daySelected, log: self.coreDataManager.logs![indexPath.row], myDatePicker: myDatePicker)
                    
                    self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
                    
                    self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
                    
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(selectAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
                
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel, handler: { action in
        }))
        
        self.present(alert, animated: true) {
            
        }
    }
    
    func makeSheet(index: Int, jadwalVars: JadwalVars){
        var isSkipped = false
        let log = coreDataManager.logs![jadwalVars.idx]
        if(log.bg_check_result != "-1"){
            isSkipped = true
        }
        
        print("rx - \(index)")
        
        let storyboard = UIStoryboard(name: "Take BG", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TakeBGViewController") as! TakeBGViewController
        
        let nav =  UINavigationController(rootViewController: vc)
        if let sheet = nav.presentationController as? UISheetPresentationController{
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 15
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            
        }
        vc.daySelected = daySelected
        vc.log = log
        
        if(isSkipped){
            log.bg_check_result = "-1"
            do{
                try coreDataManager.context.save()
            }
            catch {
                
            }
            
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.updateLogFirestore(id: log.log_id!, newLog: log)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            
            return
        }
        print(isSkipped)
        self.present(nav, animated: true,completion: nil)
        
    }
    
    func makeSheetMed(index: Int, jadwalVars: JadwalVars){
        let log = coreDataManager.logs![jadwalVars.idx]
        print("rx - \(index)")
        
        var isSkipped = false
        
        if(log.action != "Nil"){
            isSkipped = true
        }
        
        let storyboard = UIStoryboard(name: "Take Medication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TakeMedicationViewController") as! TakeMedicationViewController
        
        let nav =  UINavigationController(rootViewController: vc)
        
        if let sheet = nav.presentationController as? UISheetPresentationController{
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        vc.daySelected = daySelected
        vc.log = log
        
        if(isSkipped){
            log.action = "Nil"
            do{
                try coreDataManager.context.save()
            }
            catch {
                
            }
            
            MigrateFirestoreToCoreData.migrateFirestoreToCoreData.updateLogFirestore(id: log.log_id!, newLog: log)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newDataNotif"), object: nil)
            
            return
            
        }
        print(isSkipped)
        self.present(nav, animated: true,completion: nil)
        
    }
    
    func makeSheetShare(index: Int,jadwalVars: JadwalVars){
        
        var title = "ini title"
        let text = "GluCare"
        var content = "ini content"
        
        if(jadwalVars.type == "MED"){
            let med = coreDataManager.logs![jadwalVars.idx]
            title = "\(med.medicine_name!)"
            content = "Halo, jangan lupa untuk minum obat \(med.medicine_name!) ya pukul \(med.time!)."
            
        }else{
            let bg = coreDataManager.logs![jadwalVars.idx]
            if(bg.eat_time == 0){
                title = "Gula Darah Puasa"
                content = "Halo, jangan lupa untuk periksa gula darah puasa kamu ya jam \(bg.time!) hari ini."
            }else if(bg.eat_time == 1){
                title = "Gula Darah Sewaktu"
                content = "Jangan lupa untuk memeriksa gula darah sewaktu kamu pukul \(bg.time!) hari ini, ya."
            }else{
                title = "HbA1c"
                content = "Hai, kamu ada jadwal untuk memeriksa HbA1c di jam \(bg.time!) hari ini."
            }
            
        }

        
        // set up activity view controller
        let textToShare: [Any] = [
            MyActivityItemSource(content:content,title: title, text: text)
        ]
        

        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    
    }
}