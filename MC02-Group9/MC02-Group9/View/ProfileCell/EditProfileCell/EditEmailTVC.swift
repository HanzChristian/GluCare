//
//  EditEmailTVC.swift
//  MC02-Group9
//
//  Created by Richard Mulyadi on 13/01/23.
//

import UIKit

class EditEmailTVC: UITableViewCell {
    
    @IBOutlet weak var emailLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //emailLbl.font = .rounded(ofSize: 16, weight: .medium)
        emailLbl.text = FirebaseManager.firebaseManager.email
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUser), name: NSNotification.Name(rawValue: "refreshProfile"), object: nil)
    }
    
    @objc func refreshUser(){
        //emailLbl.font = .rounded(ofSize: 16, weight: .medium)
        emailLbl.text = FirebaseManager.firebaseManager.email
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
