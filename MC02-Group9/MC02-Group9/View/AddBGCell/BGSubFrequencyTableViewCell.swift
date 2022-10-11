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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
