//
//  ViewController+Rx.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 26/10/22.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit


extension ViewController{
    
    
    func bindDataToTableView(){
       
        coreDataManager.jadwal.asObservable()
            .bind(to: tableView.rx
                .items(cellIdentifier: "cell", cellType: TakeMedTableViewCell.self))
        {
            [weak self] index, element, cell in
            cell.idx = index
            cell.identity = element
            
            let user = self!.coreDataManager.user?[element.idx]
            
            if(element.type == "MED"){
                self!.setupCellMed(cell: cell, element: element)
            }else{
                self!.setupCellBG(cell: cell, element: element)
            }
            
            cell.takeBtn.rx.tap
                .subscribe(onNext: { [weak self] in
                    print("take btn on click rx \(cell.medLbl!.text) index: \(cell.idx)")
                    
                    if(self!.role == 1){
                        let realIdx = cell.identity.idx
                        
                        if(cell.identity.type == "BG"){
                            self!.makeSheet(index: realIdx, jadwalVars: cell.identity)
                        }else{
                            print("click rx medicineName \(self!.coreDataManager.items![cell.identity.idx].medicine?.name) with index \(cell.identity.idx)")
                            
                            self!.makeSheetMed(index: realIdx, jadwalVars: cell.identity)
                            
                        }
                    }
                    else{
                        let realIdx = cell.identity.idx
                        self!.makeSheetShare(index: realIdx,jadwalVars: cell.identity)
                    }
                    
                    
                }).disposed(by: cell.disposeBag)
            
            
        }.disposed(by: disposeBag)
        
        
    }
    
    func setupCellBG(cell: TakeMedTableViewCell, element: JadwalVars){
        let bg = self.coreDataManager.bg?[element.idx]
        let user = self.coreDataManager.user?[element.idx]
        let log = self.coreDataManager.logs?[element.logIdx]
        
        if(bg?.bg_type == 0){
            cell.freqLbl.text = "Gula Darah Puasa"
        }else if(bg?.bg_type == 1){
            cell.freqLbl.text = "Gula Darah Sesaat"
        }else{
            cell.freqLbl.text = "HbA1c"
        }
        
        cell.cellBtn.setImage(UIImage(named:"Take"), for: UIControl.State.normal)
        
        if(role == 1){
            cell.cellBtn.setImage(UIImage(named:"Take"), for: UIControl.State.normal)
        }
        else if(role  == 2){
            cell.cellBtn.setImage(UIImage(named:"RemindTake"), for: UIControl.State.normal)
        }
        
        cell.medLbl.text = "Cek Gula Darah"
        
        cell.timeLbl.text = bg?.bg_time
        
        // New
        if(log!.bg_check_result != "-1" && log!.ref_id! == bg!.bg_id){
            if(log!.action == "Skip"){
                cell.tintColor = UIColor.red
                cell.cellBtn.setImage(UIImage(named:"Skipped"), for: UIControl.State.normal)
                //                        cell.cellImgView.layer.opacity = 0.3
                //                        cell.indicatorImgView.image = UIImage(named: "Subtract")
            }
            else if(log!.action == "Take"){
                cell.tintColor = UIColor.green
                cell.cellBtn.setImage(UIImage(named:"Taken"), for: UIControl.State.normal)
                
                cell.freqLbl.text! += " (\(log!.bg_check_result!)"
                
                if(bg?.bg_type == 0 || bg?.bg_type == 1){
                    cell.freqLbl.text! += " mg/dL)"
                }else{
                    cell.freqLbl.text! += " %)"
                }
            }
        }
        
//        for (i, log) in self.coreDataManager.logs!.enumerated() {
//
//            if(log.ref_id == bg!.bg_id && bg!.bg_type == 2){
//                print("tes44 \(log.ref_id) \(bg?.bg_id)")
//                print("tes44 check result \(log.bg_check_result)")
//            }
//
//            if(log.bg_check_result != "-1" && log.ref_id! == bg!.bg_id){
//                self.coreDataManager.undoIdx[element.idx] = i
//                self.coreDataManager.keTake[element.idx] = 1
//                if(log.action == "Skip"){
//                    cell.tintColor = UIColor.red
//                    cell.cellBtn.setImage(UIImage(named:"Skipped"), for: UIControl.State.normal)
//                    //                        cell.cellImgView.layer.opacity = 0.3
//                    //                        cell.indicatorImgView.image = UIImage(named: "Subtract")
//                }
//                else if(log.action == "Take"){
//                    cell.tintColor = UIColor.green
//                    cell.cellBtn.setImage(UIImage(named:"Taken"), for: UIControl.State.normal)
//
//                    cell.freqLbl.text! += " (\(log.bg_check_result!)"
//
//                    if(bg?.bg_type == 0 || bg?.bg_type == 1){
//                        cell.freqLbl.text! += " mg/dL)"
//                    }else{
//                        cell.freqLbl.text! += " %)"
//                    }
//                }
//            }
//        }
    }
    
    
    func setupCellMed(cell: TakeMedTableViewCell, element: JadwalVars){
        
        let medicine_time = self.coreDataManager.items![element.idx]
        let user = self.coreDataManager.user?[element.idx]
        
        cell.medLbl.text = medicine_time.medicine?.name
        if(medicine_time.medicine?.eat_time == 2){
            cell.freqLbl.text = "Setelah makan"
        }
        else if(medicine_time.medicine?.eat_time == 1){
            cell.freqLbl.text = "Sebelum makan"
        }
        else if(medicine_time.medicine?.eat_time == 3){
            cell.freqLbl.text = "Bersamaan dengan makan"
        }else{
            cell.freqLbl.text = "Waktu Spesifik"
        }
        cell.timeLbl.text = medicine_time.time
        cell.tintColor = UIColor.blue
        
        cell.cellBtn.setImage(UIImage(named:"Take"), for: UIControl.State.normal)
        
        print("INI USER ROLENYA \(role)")
        if(role == 1){
            cell.cellBtn.setImage(UIImage(named:"Take"), for: UIControl.State.normal)
        }
        else if(role  == 2){
            cell.cellBtn.setImage(UIImage(named:"RemindTake"), for: UIControl.State.normal)
        }
        
        
        for (index, log) in self.coreDataManager.logs!.enumerated() {
            if(log.time == cell.timeLbl.text && log.medicine_name == cell.medLbl.text && log.ref_id == medicine_time.medicine?.id){
                
//                print("tes33 \(log.ref_id) == \(medicine_time.medicine!.id)")
                
                self.coreDataManager.undoIdx[element.idx] = index
                self.coreDataManager.keTake[element.idx] = 1
                
                if(log.action == "Skip"){
                    cell.tintColor = UIColor.red
                    cell.cellBtn.setImage(UIImage(named:"Skipped"), for: UIControl.State.normal)
                }else{
                    // Create Date Formatter
                    let dateFormatter = DateFormatter()
                    
                    // Set Date/Time Style
                    dateFormatter.dateStyle = .long
                    dateFormatter.timeStyle = .short
                    dateFormatter.dateFormat = "HH:mm"
                    
                    // Convert Date to String
                    var date = dateFormatter.string(from: log.dateTake!)
                    
                    cell.tintColor = UIColor.green
                    cell.cellBtn.setImage(UIImage(named:"Taken"), for: UIControl.State.normal)
                    
                    cell.freqLbl.text = "Diminum pada \(date)"
                }
                break
            }
            
        }
    }
    
    
}
