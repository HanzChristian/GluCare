//
//  ExitTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 03/11/22.
//

import UIKit
import FirebaseAuth

class ExitTVC: UITableViewCell {
    
    @IBOutlet weak var exitLbl: UILabel!
    
    @IBAction func logoutPress(_ sender: UIButton){
        
    }
        
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//
//            CoreDataManager.coreDataManager.resetAllCoreData()
//
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passLogin"), object: nil)
//
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//
//        }


    override func awakeFromNib() {
        super.awakeFromNib()
        //exitLbl.inputAccessoryView =
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
