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

            
            if(element.type == "MED"){
                self!.setupCellMed(cell: cell, element: element)
            }else{
                self!.setupCellBG(cell: cell, element: element)
            }
            
            cell.takeBtn.rx.tap
                .subscribe(onNext: { [weak self] in
                    if(self!.role == 1){
                        let realIdx = cell.identity.idx
                        
                        if(cell.identity.type == "BG"){
                            self!.makeSheet(index: realIdx, jadwalVars: cell.identity)
                        }else{
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
        let log = self.coreDataManager.logs?[element.idx]
        
        if(log?.eat_time == 0){
            cell.freqLbl.text = "Gula Darah Puasa"
        }else if(log?.eat_time == 1){
            cell.freqLbl.text = "Gula Darah Sewaktu"
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
        
        cell.timeLbl.text = log?.time!
        
        // New
        if(log!.bg_check_result != "-1"){
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
                
                if(log?.eat_time == 0 || log?.eat_time == 1){
                    cell.freqLbl.text! += " mg/dL)"
                }else{
                    cell.freqLbl.text! += " %)"
                }
            }
        }
    }
    
    
    func setupCellMed(cell: TakeMedTableViewCell, element: JadwalVars){
        let log = self.coreDataManager.logs![element.idx]
        
        cell.medLbl.text = log.medicine_name
        if(log.eat_time == 2){
            cell.freqLbl.text = "Setelah makan"
        }
        else if(log.eat_time == 1){
            cell.freqLbl.text = "Sebelum makan"
        }
        else if(log.eat_time == 3){
            cell.freqLbl.text = "Bersamaan dengan makan"
        }else{
            cell.freqLbl.text = "Waktu Spesifik"
        }
        cell.timeLbl.text = log.time
        cell.tintColor = UIColor.blue
        
        cell.cellBtn.setImage(UIImage(named:"Take"), for: UIControl.State.normal)
        
        print("INI USER ROLENYA \(role)")
        if(role == 1){
            cell.cellBtn.setImage(UIImage(named:"Take"), for: UIControl.State.normal)
        }
        else if(role  == 2){
            cell.cellBtn.setImage(UIImage(named:"RemindTake"), for: UIControl.State.normal)
        }
        
        if(log.action == "Skip"){
            cell.tintColor = UIColor.red
            cell.cellBtn.setImage(UIImage(named:"Skipped"), for: UIControl.State.normal)
        }else if(log.action != "Nil"){
            // Create Date Formatter
            let dateFormatter = DateFormatter()
            
            // Set Date/Time Style
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            dateFormatter.dateFormat = "HH:mm"
            
            // Convert Date to String
            let date = dateFormatter.string(from: log.dateTake!)
            
            cell.tintColor = UIColor.green
            cell.cellBtn.setImage(UIImage(named:"Taken"), for: UIControl.State.normal)
            
            cell.freqLbl.text = "Diminum pada \(date)"
        }
    }
    
    
}
