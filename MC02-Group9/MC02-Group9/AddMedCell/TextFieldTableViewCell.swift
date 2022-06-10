//
//  TextFieldTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 11/06/22.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    @IBOutlet var cell1NameLabel: UILabel!
    @IBOutlet var cell1TextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
