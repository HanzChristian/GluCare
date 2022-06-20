//
//  TextFieldTableViewCell.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 11/06/22.
//

import UIKit

class MedNameTextFieldTVC: UITableViewCell {
    
    @IBOutlet var medNameTextField: UITextField!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
            medNameTextField.layer.cornerRadius = 16.0
            medNameTextField.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
