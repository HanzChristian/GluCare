//
//  ViewController+TableViewDataSource.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 24/10/22.
//

import Foundation
import UIKit

extension ViewController{
    
    func mergeTV(){

        jadwalVars.removeAll()
        print("MASUK 666 KE REMOVE")
        self.coreDataManager.fetchMedicine(tableView: tableView)
        self.coreDataManager.fetchBGTime(daySelected: daySelected)
        self.coreDataManager.fetchBG()
        self.coreDataManager.fetchLogs(tableView: tableView, daySelected: daySelected)
        
        var bgLog = [Log]()
        var lowest = "24:00"
        var medIdx = 0
        var bgIdx = 0
        
        guard var medCopy = self.coreDataManager.items else{
            print("MASUK SINI med")
            return
        }
        
        guard var bgCopy = self.coreDataManager.bg else{
            print("MASUK SINI")
            return
        }
        
        print("INI MEDCOPY \(medCopy.count)")
        
        guard var logs = self.coreDataManager.logs else{
            return
        }

        print("INI LOG AWAL Begin")
        for log in logs{ //menentukan log bg atau med
            if log.type == 1{
                bgLog.append(log)
                print("INI LOG AWAL \(log.time) \(log.log_id)")
            }
            print("INI LOG DUA \(log.type) \(log.time)")
        }
        
        print("INI LOG AWAL END")
        while(medCopy.count != 0){
            
            var idxBg = 0
            var idxLowestBg = -1
            var lowestBg = "24:00"
            var idxLog = 0
            var idxLogLowestBg = -1
            
            
            for bg in bgCopy{
                idxLog = 0
                for log in bgLog{ //menentukan log bg atau med
                    if log.time == bg.bg_time && log.ref_id == bg.bg_id{
                        if((bg.bg_time)! < medCopy[0].time! && (bg.bg_time)! < lowestBg){
                            lowestBg = (bg.bg_time)!
                            idxLowestBg = idxBg
                            idxLogLowestBg = idxLog
                        }
                    }
                    idxLog += 1
                    
                }
                idxBg += 1
            }
            
            if(idxLowestBg == -1){ //med lebih kecil
                var j = JadwalVars(type: "MED", idx: medIdx)
                
                let logIdx = coreDataManager.getLogRealIdx(med: medCopy[0])
                if logIdx != -1 {
                    j.logIdx = logIdx
                }
                
                jadwalVars.append(j)
                medCopy.remove(at: 0)
                medIdx += 1
            }else{ //bg lebih kecil
                var j = JadwalVars(type: "BG", idx: getBgIdx(bG: bgCopy[idxLowestBg]))
                j.logIdx = coreDataManager.getLogRealIdx(log: bgLog[idxLogLowestBg], bg: bgCopy[idxLowestBg])
                jadwalVars.append(j)
                bgCopy.remove(at: idxLowestBg)
                bgLog.remove(at: idxLogLowestBg)
            }
        }
//        cari bg terkecil masuk ke jadwalVar
        for bg in bgCopy{
            for log in bgLog{
                if log.time == bg.bg_time && log.ref_id == bg.bg_id{
                    
                    var j = JadwalVars(type: "BG", idx: getBgIdx(bG: bg))
                    j.logIdx = coreDataManager.getLogRealIdx(log: log, bg: bg)
                    jadwalVars.append(j)
                }
                print("ini lognya \(log)")
            }
            print("ini bgnya \(bg)")
        
        }

        for bg in coreDataManager.bg!{
            print("BGTIME \(bg.bg_time)")
        }
        print("JADWALVARS \(jadwalVars) \(coreDataManager.bg)")
        
        
        for asd in jadwalVars{
            print("jadwal222 \(asd.logIdx)")
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
