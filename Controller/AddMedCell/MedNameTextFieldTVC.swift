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
        medNameTextField.addTarget(self, action: #selector(txtFieldEdit(_:)), for: .editingChanged)
        print("INI NAMA OBAT")
        print(medNameTextField.text!)
    }
    
    @objc func txtFieldEdit(_ textField:UITextField){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
