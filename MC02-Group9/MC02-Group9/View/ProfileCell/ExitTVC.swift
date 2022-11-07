//
//  ExitTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 03/11/22.
//

import UIKit
import FirebaseAuth

class ExitTVC: UITableViewCell {
    
    
    @IBAction func logoutPress(_ sender: UIButton){
        print("hello")
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passLogin"), object: nil)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
