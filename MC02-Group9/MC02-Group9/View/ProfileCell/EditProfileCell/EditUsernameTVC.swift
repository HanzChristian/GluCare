//
//  EditUsernameTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class EditUsernameTVC: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var nameTxt: UITextField!
    
    let db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let nama = UserDefaults.standard.string(forKey: "nama")
        
        nameTxt.addTarget(self, action: #selector(nameTxtEdit(_:)), for: .editingChanged)
        nameTxt.attributedPlaceholder = NSAttributedString(
            string: FirebaseManager.firebaseManager.name,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
        print("db col id", db.collection("account").parent)
        

        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
        
    }
    @objc func nameTxtEdit(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "formValidateNotif"), object: nil)
    }
    
    @objc func refreshUser(){
        nameTxt.attributedPlaceholder = NSAttributedString(
            string: FirebaseManager.firebaseManager.name,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
        )
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
