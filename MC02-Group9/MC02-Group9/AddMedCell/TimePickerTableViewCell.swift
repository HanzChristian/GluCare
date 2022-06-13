//
//  TimePickerTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 13/06/22.
//

import UIKit

class TimePickerTableViewCell: UITableViewCell{
    
   
    
    @IBOutlet weak var lblTimePicker: UILabel!
    @IBOutlet weak var btnTimePicker: UITextField!
    let date = Date()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}



