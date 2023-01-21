//
//  EditEmailTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class EditEmailTVC: UITableViewCell {
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //emailLbl.font = .rounded(ofSize: 16, weight: .medium)
        //emailLbl.text = FirebaseManager.firebaseManager.email
        
        emailTxt.addTarget(self, action: #selector(emailTxtEdit(_:)), for: .editingChanged)
        emailTxt.attributedPlaceholder = NSAttributedString(
            string: FirebaseManager.firebaseManager.email,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
    }
    @objc func emailTxtEdit(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
    }
    
    @objc func refreshUser(){
        //emailLbl.font = .rounded(ofSize: 16, weight: .medium)
        emailTxt.addTarget(self, action: #selector(emailTxtEdit(_:)), for: .editingChanged)
        emailTxt.attributedPlaceholder = NSAttributedString(
            string: FirebaseManager.firebaseManager.email,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
