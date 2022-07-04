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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblOnTime.text = "Tepat Waktu"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
