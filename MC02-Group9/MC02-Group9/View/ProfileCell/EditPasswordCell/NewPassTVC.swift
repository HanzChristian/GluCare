//
//  NewPassTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit

class NewPassTVC: UITableViewCell {

    @IBOutlet weak var newPassTxt: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        newPassTxt.addTarget(self, action: #selector(newPassEdit(_:)), for: .editingChanged)
        newPassTxt.attributedPlaceholder = NSAttributedString(
            string: FirebaseManager.firebaseManager.name,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )

        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)

        // Initialization code
    }
    @objc func newPassEdit(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
    }
    
    @objc func refreshUser(){
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
