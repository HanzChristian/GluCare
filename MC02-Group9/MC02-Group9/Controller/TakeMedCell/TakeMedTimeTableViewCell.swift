//
//  TakeMedTimeTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 04/07/22.
//

import UIKit

class TakeMedTimeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblTakeMedTime: UILabel!
    @IBOutlet weak var btnDatePicker: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblTakeMedTime.text = "Waktu Minum"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
