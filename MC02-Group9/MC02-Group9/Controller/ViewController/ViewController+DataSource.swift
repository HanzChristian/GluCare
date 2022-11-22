//
//  ViewController+TableViewDataSource.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 24/10/22.
//

import Foundation
import UIKit

extension ViewController{
    
    func checkAvailableInitLog(daySelected: Date){
        self.coreDataManager.fetchMeds()
        self.coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        coreDataManager.checkMedLogAvailable(logs: coreDataManager.logs!, meds: coreDataManager.medicines!, dayselected: daySelected)
        
    }
    
    func mergeTV(){
        
        self.coreDataManager.fetchBG()
        checkAvailableInitLog(daySelected: daySelected)
        coreDataManager.checkBGLogAvailable(logs: coreDataManager.logs!, bgs: coreDataManager.bg!, daySelected: daySelected)
        jadwalVars.removeAll()
        self.coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        
        guard let logs = self.coreDataManager.logs else{
            return
        }
        
        var idx = 0
        for log in logs {
            if log.type == 0{
                jadwalVars.append(JadwalVars(type: "MED", idx: idx))
            }else{
                jadwalVars.append(JadwalVars(type: "BG", idx: idx))
            }
            
            idx += 1
        }

        
        coreDataManager.jadwal.accept(jadwalVars)
    }
    
    func getBgIdx(bG:BG) -> Int{
        var i = 0
        for bg in coreDataManager.bg!{
            if(bg == bG){
                return i
            }
            i += 1
        }
        return -1
    }
    
    
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    ////        if(dataType == "BG"){
    ////            return self.coreDataManager.bgTime?.count ?? 0
    ////        }else{
    ////            return self.coreDataManager.items?.count ?? 0
    ////        }
    //        return jadwalVars.count ?? 0
    //
    //    }
    
    func showToastSkip(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        
        toastLabel.backgroundColor = UIColor(rgb: 0xDE6FB3)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastTake(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        
        toastLabel.backgroundColor = UIColor(rgb: 0x56A3D4)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func showToastUndo(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 16, y: 690, width: 358, height: 48))
        toastLabel.backgroundColor = .gray
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 8;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
