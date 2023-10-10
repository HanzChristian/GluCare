//
//  MedNameTableViewCell.swift
//  MC02-Group9
//
//  Created by Marcelino Budiman on 04/07/22.
//

import UIKit

class MedNameTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMedname: UILabel!
    @IBOutlet weak var lblMedTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
