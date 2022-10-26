//
//  BGResultTableViewCell.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 05/10/22.
//

import UIKit

class BGResultTableViewCell: UITableViewCell {

    @IBOutlet weak var BGInputLbl: UITextField!
    @IBOutlet weak var BGUnitLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        BGUnitLbl.font = UIFont.boldSystemFont(ofSize: 16)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
