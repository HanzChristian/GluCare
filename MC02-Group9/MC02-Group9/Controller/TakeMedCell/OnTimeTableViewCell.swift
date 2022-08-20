//
//  OnTimeTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 04/07/22.
//

import UIKit

class OnTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOnTime: UILabel!
    @IBOutlet weak var switchOnTime: UISwitch!
    
    let coreDataManager = CoreDataManager.coreDataManager
    var daySelected = Date()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblOnTime.text = "Tepat Waktu"
        switchOnTime.isOn = false
        
    }
    
    @IBAction func switchDidChange(_ sender: UISwitch){
        if switchOnTime.isOn{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "switchOn"), object: nil)
//            self.coreDataManager.tepatWaktu(daySelected: self.daySelected, indexPath: IndexPath)
        }
        else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "switchOff"), object: nil)
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
