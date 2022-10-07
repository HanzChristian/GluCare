//
//  BtnSaveTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 05/07/22.
//

import UIKit

class BtnSaveTableViewCell: UITableViewCell {

    var cellMedNameTV: MedNameTextFieldTVC?
    let coreDataManager = CoreDataManager.coreDataManager
    
    
    @IBOutlet weak var btnSave: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnSave.titleLabel?.text = "Simpan"
        
        
    }
    
    
    @IBAction func didTapBtn(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "save"), object: nil)
//        self.dismiss(animated: true, completion: {
//        self.coreDataManager.pilihWaktu(daySelected: self.daySelected, indexPath: indexPath, myDatePicker: myDatePicker)
//
//        self.showToastTake(message: "Obat berhasil dikonsumsi.", font: .systemFont(ofSize: 12.0))
//
//        self.coreDataManager.fetchLogs(tableView: self.tableView, daySelected: self.daySelected)
//
//        self.streakManager.validateNewStreak(daySelected: self.daySelected, tableView: self.tableView)
//        })

                     
    }
    
 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
