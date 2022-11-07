//
//  UsernameTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 27/10/22.
//

import UIKit

class UsernameTVC: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userNameLbl.font = .rounded(ofSize: 16, weight: .semibold)
        // Initialization code
        
        
        userNameLbl.text = FirebaseManager.firebaseManager.name
        userEmailLbl.text = FirebaseManager.firebaseManager.email
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
        
    }
    
    @objc func refreshUser(){
        userNameLbl.text = FirebaseManager.firebaseManager.name
        userEmailLbl.text = FirebaseManager.firebaseManager.email
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
