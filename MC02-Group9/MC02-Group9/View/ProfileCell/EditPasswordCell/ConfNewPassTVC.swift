//
//  ConfNewPassTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit

class ConfNewPassTVC: UITableViewCell {

    @IBOutlet weak var confNewPassTxt: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        confNewPassTxt.addTarget(self, action: #selector(confNewPassEdit(_:)), for: .editingChanged)
        confNewPassTxt.attributedPlaceholder = NSAttributedString(
            string: FirebaseManager.firebaseManager.name,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )

        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
        // Initialization code
    }
    
    @objc func confNewPassEdit(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
    }
    
    @objc func refreshUser(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
