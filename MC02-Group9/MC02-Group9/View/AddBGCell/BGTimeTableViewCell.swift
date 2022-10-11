//
//  BGTimeTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 11/10/22.
//

import UIKit

class BGTimeTableViewCell: UITableViewCell {

    @IBOutlet var bgTimeLbl:UILabel!
    @IBOutlet var bgTimeBtn:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
