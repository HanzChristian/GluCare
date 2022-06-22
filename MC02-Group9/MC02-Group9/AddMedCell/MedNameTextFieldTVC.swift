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
//            medNameTextField.layer.cornerRadius = 16.0
            medNameTextField.clipsToBounds = true
        print("INI NAMA OBAT")
        print(medNameTextField.text!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
