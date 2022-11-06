//
//  ViewController+TableViewDelegate.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 24/10/22.
//

import Foundation
import UIKit

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func showActionSheet(indexPath: IndexPath) {
        let alert = UIAlertController(title: "", message: "Kapan kamu mengonsumsi obat ini?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Tepat Waktu", style: .default, handler: { action in
            //print("Tepat Waktu tapped")
            
            self.coreDataManager.tepatWaktu(daySelected: daySelected, indexPath: indexPath)
            
            self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
            
            self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
            
            self.streakManager.validateNewStreak(daySelected: daySelected, tableView: self.tableView)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Pilih Waktu", style: .default, handler: { action in
            //print("Pilih Waktu tapped")
            // Gas
            
            self.dismiss(animated: true, completion: {
                
                
                let myDatePicker: UIDatePicker = UIDatePicker()
                myDatePicker.preferredDatePickerStyle = .wheels
                myDatePicker.timeZone = TimeZone.init(identifier: "ICT")
                myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
                let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
                
                alertController.view.addSubview(myDatePicker)
                
                let selectAction = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    
                    self.coreDataManager.pilihWaktu(daySelected: daySelected, indexPath: indexPath, myDatePicker: myDatePicker)
                    
                    self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
                    
                    self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
                    
                    self.streakManager.validateNewStreak(daySelected: daySelected, tableView: self.tableView)
                    
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(selectAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
                
            })
            
        }))
        
        /*
         alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
         
         }))
         
         */
        alert.addAction(UIAlertAction(title: "Kembali", style: .cancel, handler: { action in
        }))
        
        self.present(alert, animated: true) {
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    @objc func makeSheet(index: Int){
        
        let idx = index
        
        print("rx - \(index)")
        self.isSkipped = false
        
        if (coreDataManager.undoIdx[idx] >= 0){
            coreDataManager.keTake[idx] = -1
            self.isSkipped = true
        }
        
        let storyboard = UIStoryboard(name: "Take BG", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TakeBGViewController") as! TakeBGViewController
        
        let nav =  UINavigationController(rootViewController: vc)
        //        nav.modalPresentationStyle = .overCurrentContext
        
        if let sheet = nav.presentationController as? UISheetPresentationController{
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            
        }
        vc.daySelected = daySelected
        vc.indexPath = IndexPath(row: idx,section : 0)
        vc.bg = coreDataManager.bg![idx]
        vc.tblViewBG = self.tableView
        if(isSkipped){
            //isi dari untake action
            let logToRemove = self.coreDataManager.logs![self.coreDataManager.undoIdx[vc.indexPath!.row]]
            coreDataManager.batalkan(logToRemove: logToRemove)
            
            self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
        }
        coreDataManager.medicineSelectedIdx = vc.indexPath!.row
        print("INI IDX NYA \(vc.indexPath)")
        print(self.isSkipped)
        self.present(nav, animated: true,completion: nil)
        
    }
    
//    func untakeMedSheet(index: Int){
//        let idx = index
//        self.isSkipped = false
//        //
//        if (coreDataManager.undoIdx[idx] >= 0){
//            coreDataManager.keTake[idx] = -1
//            self.isSkipped = true
//        }
//        
//        let storyboard = UIStoryboard(name: "Take Medication", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "TakeMedicationViewController") as! TakeMedicationViewController
//        
//        vc.daySelected = daySelected
//        vc.indexPath = IndexPath(row: idx,section : 0)
//        vc.tableView = self.tableView
//        
//        if(isSkipped){
//            //isi dari untake action
//            let logToRemove = self.coreDataManager.logs![self.coreDataManager.undoIdx[vc.indexPath!.row]]
//            coreDataManager.batalkan(logToRemove: logToRemove)
//            
//            self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
//            
//            coreDataManager.fetchStreak()
//            if(coreDataManager.streaks!.isEmpty == true){
//                return
//            }
//            //             Streak Logic
//            let dateFrom = calendarManager.calendar.startOfDay(for: Date())
//            let lastDate = coreDataManager.streaks![coreDataManager.streaks!.count - 1].date
//            
//            if(lastDate == dateFrom){
//                // Streak nya udah ketambah di hari yg sama
//                
//                coreDataManager.removeStreak(streakToRemove: coreDataManager.streaks!.last!)
//                coreDataManager.fetchStreak()
//            }
//            
//        }
//    }
    
    func makeSheetMed(index: Int){
        let idx = index
        
        print("rx - \(index)")
        //
        //        print("debug1: idx \(idx)")
        self.isSkipped = false
        //
        if (coreDataManager.undoIdx[idx] >= 0){
            coreDataManager.keTake[idx] = -1
            self.isSkipped = true
        }
        
        let storyboard = UIStoryboard(name: "Take Medication", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TakeMedicationViewController") as! TakeMedicationViewController
        
        let nav =  UINavigationController(rootViewController: vc)
        //        nav.modalPresentationStyle = .overCurrentContext
        
        if let sheet = nav.presentationController as? UISheetPresentationController{
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            
        }
        
        vc.daySelected = daySelected
        vc.indexPath = IndexPath(row: idx,section : 0)
        vc.tableView = self.tableView
        if(isSkipped){
            //isi dari untake action
            let logToRemove = self.coreDataManager.logs![self.coreDataManager.undoIdx[vc.indexPath!.row]]
            coreDataManager.batalkan(logToRemove: logToRemove)
            
            self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: daySelected)
            
            coreDataManager.fetchStreak()
            if(coreDataManager.streaks!.isEmpty == true){
                return
            }
            //             Streak Logic
            let dateFrom = calendarManager.calendar.startOfDay(for: Date())
            let lastDate = coreDataManager.streaks![coreDataManager.streaks!.count - 1].date
            
            if(lastDate == dateFrom){
                // Streak nya udah ketambah di hari yg sama
                
                coreDataManager.removeStreak(streakToRemove: coreDataManager.streaks!.last!)
                coreDataManager.fetchStreak()
            }
            
        }
        coreDataManager.medicineSelectedIdx = vc.indexPath!.row
        print("INI IDX NYA \(vc.indexPath)")
        print(self.isSkipped)
        self.present(nav, animated: true,completion: nil)
        
    }
    
    func makeSheetShare(index: Int,jadwalVars: JadwalVars){
        
        var title = "ini title"
        var text = "GluCare"
        var content = "ini content"
        
        if(jadwalVars.type == "MED"){
            let med = coreDataManager.items![jadwalVars.idx]
            title = "\(med.medicine!.name!)"
            content = "Hi, Kamu belum mengonsumsi \(med.medicine!.name!) nih! Minum segera ya!"
            
        }else{
            let bg = coreDataManager.bg![jadwalVars.idx]
            if(bg.bg_type == 0){
                title = "Gula Darah Puasa"
                content = "Hi, Kamu belum cek Gula Darah Puasa nih! Cepat di cek ya!"
            }else if(bg.bg_type == 1){
                title = "Gula Darah Sesaat"
                content = "Hi, Kamu belum cek Gula Darah Sesaat nih! Cepat di cek ya!"
            }else{
                title = "HBA1C"
                content = "Hi, Kamu belum cek HBA1C nih! Cepat di cek ya!"
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
