//
//  BGSubFrequencyTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 11/10/22.
//

import UIKit

class BGSubFrequencyTableViewCell: UITableViewCell {
    
    @IBOutlet var bgSubFrequencyEveryLbl: UILabel!
    @IBOutlet var bgsubFrequencyTxtField:UITextField!
    @IBOutlet var bgFrequencyLbl: UILabel!
    
    let scheduleTime = ["Hari","Minggu","Bulan"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "changeSub"), object: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func refresh(){
        bgFrequencyLbl.text = scheduleTime[scheduleTimeVar.row]
        super.setSelected(isSelected, animated: true)
    }
    
}
